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
    const client = await pool.connect();
    let query = 'SELECT * FROM recipes WHERE 1=1'; // Base SQL query

    const { kkal, meal_type, diet } = req.query;

    if (kkal) query += ` AND kkal <= ${kkal}`;
    if (meal_type) query += ` AND meal_type = '${meal_type}'`;
    if (diet) {
      const dietsArray = Array.isArray(diet) ? diet : [diet];
      query += ` AND diet IN (${dietsArray.map(d => `'${d}'`).join(',')})`;
    }

    const result = await client.query(query);
    const recipes = result.rows;

    client.release();

    res.json({ recipes });
  } catch (error) {
    console.error('Error fetching recipes:', error);
    res.status(500).send('Failed to fetch recipes');
  }
});


app.post('/diary/add', async (req, res) => {
  try {
    const { token, recipeId, name, mealType, recipeKkal, recipeProtein, recipeFats, recipeCarbohydrates } = req.body;
    console.log(req.body);

    if (!token) {
      return res.status(400).send('Токен отсутствует');
    }
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');  
    const userQuery = await pool.query('SELECT user_id FROM users WHERE email = $1', [decoded.email]);
    
    if (userQuery.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }
    
    // Извлекаем userID из результата запроса
    const userId = userQuery.rows[0].user_id;
    console.log(userId);

    // Добавление записи в дневник
    const addDiaryEntryQuery = {
      text: 'INSERT INTO diary (date, user_id, recipe_id, name, meal_type, kkal, protein, fats, carbohydrates) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)',
      values: [new Date(), userId, recipeId, name, mealType, recipeKkal, recipeProtein, recipeFats, recipeCarbohydrates],
    };
    await pool.query(addDiaryEntryQuery);

    res.status(200).send('Запись успешно добавлена в дневник.');
  } catch (error) {
    console.error('Ошибка:', error.message);
    res.status(500).send('Произошла ошибка при добавлении записи в дневник.');
  }
});

app.get('/user/recipes', async (req, res) => {
  const token = req.header('Authorization').replace('Bearer ', '');

  if (!token) {
    return res.status(400).send('Токен отсутствует');
  }

  try {
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');

    const userQuery = await pool.query('SELECT user_id FROM users WHERE email = $1', [decoded.email]);

    if (userQuery.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }

    // Извлекаем userID из результата запроса
    const userId = userQuery.rows[0].user_id;
    console.log(userId);

    // Получаем рецепты пользователя на сегодня
    const currentDate = new Date().toLocaleDateString();
    const userRecipes = await pool.query(`
      SELECT * FROM diary
      WHERE user_id = $1 AND date = $2
    `, [userId, currentDate]);

    res.json(userRecipes.rows);

    console.log(userRecipes.rows);
  } catch (error) {
    console.error('Ошибка при получении рецептов пользователя:', error);
    res.status(500).json({ error: 'Ошибка сервера' });
  }
});

app.post('/favorites/toggle', async (req, res) => {
  const { token, favoriteData } = req.body;
  console.log(token, favoriteData);
  try {
    if (!token) {
      return res.status(400).send('Токен отсутствует');
    }
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');  
    const userQuery = await pool.query('SELECT user_id FROM users WHERE email = $1', [decoded.email]);
    
    if (userQuery.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }
    
    // Извлекаем userID из результата запроса
    const userId = userQuery.rows[0].user_id;
    console.log(userId);

    // Получаем данные о рецепте и его статусе избранного
    const { recipeId, isFavorite } = favoriteData;
    console.log(recipeId, isFavorite);

    // Выполняем запрос к базе данных для добавления или удаления рецепта из избранного
    if (isFavorite) {
      await pool.query('INSERT INTO favorites (user_id, recipe_id) VALUES ($1, $2)', [userId, recipeId]);
    } else {
      await pool.query('DELETE FROM favorites WHERE user_id = $1 AND recipe_id = $2', [userId, recipeId]);
    }

    // Отправляем успешный статус
    res.sendStatus(200);
  } catch (error) {
    console.error('Ошибка при добавлении/удалении рецепта из избранного:', error);
    res.sendStatus(500);
  }
});

app.post('/favorites/status', async (req, res) => {
  const { token, recipeId } = req.body;

  try {
    if (!token) {
      return res.status(400).send('Токен отсутствует');
    }
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');  
    const userQuery = await pool.query('SELECT user_id FROM users WHERE email = $1', [decoded.email]);
    const userId = userQuery.rows[0].user_id;

    const query = 'SELECT COUNT(*) AS count FROM favorites WHERE user_id = $1 AND recipe_id = $2';
    const result = await pool.query(query, [userId, recipeId]);
    const isFavorite = result.rows[0].count > 0;

    res.json({ isFavorite });
  } catch (error) {
    console.error('Ошибка проверки статуса избранного рецепта:', error);
    res.status(500).send('Внутренняя ошибка сервера');
  }
});

app.get('/favorites/recipes', async (req, res) => {
  const token = req.headers.authorization.split(' ')[1];

  try {
    const decoded = jwt.verify(token, 'NA-3aFhPebH?9U_RqwLskGzCB');
    const user = await pool.query('SELECT * FROM users WHERE email = $1', [decoded.email]);
    if (user.rows.length === 0) {
      return res.status(404).send('Пользователь не найден');
    }
    
    const userId = user.rows[0].user_id;
    
    const query = `
      SELECT recipes.* 
      FROM recipes 
      INNER JOIN favorites ON recipes.recipe_id = favorites.recipe_id 
      WHERE favorites.user_id = $1;
    `;
    const result = await pool.query(query, [userId]);
    const favoriteRecipes = result.rows;

    res.status(200).json(favoriteRecipes);
  } catch (error) {
    console.error('Ошибка при получении избранных рецептов:', error);
    res.status(500).send('Внутренняя ошибка сервера');
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
