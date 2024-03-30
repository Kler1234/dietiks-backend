const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');
const jwt = require('jsonwebtoken');
const app = express();
const PORT = process.env.PORT || 3000;

// Подключение к базе данных PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'dietiks',
  password: 'root',
  port: 5432,
});

// Middleware
app.use(bodyParser.json());
app.use(cors());

app.post('/register', async (req, res) => {
  const { email, password, name } = req.body;
  console.log('Received register request:', { email, password, name });
  try {
    const existingUser = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).send('Такой пользователь уже существует');
    }
    await pool.query('INSERT INTO users (email, password, username) VALUES ($1, $2, $3)', [email, password, name]);
    const user = { email, password };
    const token = jwt.sign(user, 'NA-3aFhPebH?9U_RqwLskGzCB');
    res.status(201).json({ token });
  } catch (error) {
    console.error('Error registering user', error);
    res.status(500).send('Произошла ошибка');
  }
});

app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  console.log('Received login request:', { email, password });
  try {
    const result = await pool.query('SELECT * FROM users WHERE email = $1 AND password = $2', [email, password]);
    if (result.rows.length > 0) {
      const user = { email, password };
      const token = jwt.sign(user, 'NA-3aFhPebH?9U_RqwLskGzCB');
      res.status(200).json({ token });
    } else {
      res.status(401).send('Неверная почта или пароль');
    }
  } catch (error) {
    console.error('Ошибка входа', error);
    res.status(500).send('Не удалось выполнить вход');
  }
});

app.get('/autocomplete/:searchTerm', async (req, res) => {
  const searchTerm = req.params.searchTerm.toLowerCase();
  try {
    const result = await pool.query('SELECT * FROM products WHERE LOWER(name_product) LIKE $1', [`%${searchTerm}%`]);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching autocomplete results', error);
    res.status(500).send('Failed to fetch autocomplete results');
  }
});

app.get('/product/:name', async (req, res) => {
  const productName = req.params.name.toLowerCase();
  try {
    const result = await pool.query('SELECT * FROM products WHERE LOWER(name_product) = $1', [productName]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send('Product not found');
    }
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).send('Internal server error');
  }
});

app.post('/product', async (req, res) => {
  const newProduct = req.body;
  try {
    await pool.query('INSERT INTO products (name_product, kkal, protein, fats, carbohydrates) VALUES ($1, $2, $3, $4, $5)',
      [newProduct.name, newProduct.kkal, newProduct.protein, newProduct.fats, newProduct.carbohydrates]);
    res.status(201).send('Product added successfully');
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).send('Internal server error');
  }
});

app.get('/recipes', async (req, res) => {
  try {
    const recipes = await fetchRecipes();
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.json(recipes);
  } catch (error) {
    console.error('Error fetching recipes:', error);
    res.status(500).send('Failed to fetch recipes');
  }
});



app.post('/recipes/moderation', async (req, res) => {
  const { recipe_id, moderator_id } = req.body;
  try {
    await pool.query('INSERT INTO recipe_moderation (recipe_id, moderator_id, status) VALUES ($1, $2, $3)', [recipe_id, moderator_id, 'pending']);
    res.status(201).send('Recipe added for moderation');
  } catch (error) {
    console.error('Error adding recipe for moderation', error);
    res.status(500).send('Failed to add recipe for moderation');
  }
});


app.post('/calculate', async (req, res) => {
  const { token, bzhuData } = req.body;

  try {
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');
    const user = await pool.query('SELECT * FROM users WHERE email = $1', [decoded.email]);
    if (user.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }

    // Добавляем результаты БЖУ в базу данных
    await pool.query('UPDATE users SET protein = $1, fat = $2, carbohydrate = $3, calorie_result = $4 WHERE email = $5',
      [ bzhuData.proteins, bzhuData.fats, bzhuData.carbs, bzhuData.calories, decoded.email]);

    res.status(201).send('Результаты БЖУ успешно сохранены');
  } catch (error) {
    console.error('Ошибка сохранения результатов БЖУ', error);
    res.status(500).send('Ошибка сохранения результатов БЖУ');
  }
});

app.post('/user/changeUsername', async (req, res) => {
  const {token, newUsername} = req.body;
  console.log({token, newUsername});
  try{
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');
    const user = await pool.query('SELECT * FROM users WHERE email = $1', [decoded.email]);
    if (user.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }
    await pool.query('UPDATE users SET username = $1 WHERE email = $2',
      [ newUsername, decoded.email]);

    res.status(201).send('Username has been changed');
  } catch (error) {
    console.error('Error to change the username', error);
    res.status(500).send('Error to change the username');
  }
  });

  app.post('/user/changePassword', async(req, res) => {
    const {token, oldPassword, newPassword} = req.body;
    console.log({token, oldPassword, newPassword});
    try {
      const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');
      const user = await pool.query('SELECT * FROM users WHERE email = $1', [decoded.email]);
      if (user.rows.length === 0) {
        return res.status(404).send('Пользователь не найден');
      }
      // Проверка старого пароля
      if (user.rows[0].password !== oldPassword) {
        return res.status(401).send('Неправильный старый пароль');
      }
      // Обновление пароля
      await pool.query('UPDATE users SET password = $1 WHERE email = $2',
        [newPassword, decoded.email]);
      res.status(201).send('Пароль успешно изменен');
    } catch (error) {
      console.error('Ошибка при изменении пароля', error);
      res.status(500).send('Ошибка при изменении пароля');
    }
  });

app.get('/user/profile', async (req, res) => {
  const token = req.headers.authorization.split(' ')[1];

  try {
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');
    const user = await pool.query('SELECT * FROM users WHERE email = $1', [decoded.email]);
    if (user.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }
    const { username, protein, fat, carbohydrate, calorie_result } = user.rows[0];
    res.status(200).json({ username, protein, fat, carbohydrate, calorie_result });
  } catch (error) {
    console.error('Ошибка при получении данных пользователя', error);
    res.status(500).send('Ошибка при получении данных пользователя');
  }
});

// Запуск сервера
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
