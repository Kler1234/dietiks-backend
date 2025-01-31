PGDMP  :    %                |            dietiks    16.2    16.2 .               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16396    dietiks    DATABASE     {   CREATE DATABASE dietiks WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE dietiks;
                postgres    false            �            1259    32786    diary    TABLE     �  CREATE TABLE public.diary (
    entry_id integer NOT NULL,
    date date NOT NULL,
    user_id integer NOT NULL,
    recipe_id integer NOT NULL,
    name character varying(100) NOT NULL,
    meal_type character varying(50) NOT NULL,
    kkal double precision NOT NULL,
    protein double precision NOT NULL,
    fats double precision NOT NULL,
    carbohydrates double precision NOT NULL
);
    DROP TABLE public.diary;
       public         heap    postgres    false            �            1259    32785    diary_entry_id_seq    SEQUENCE     �   CREATE SEQUENCE public.diary_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.diary_entry_id_seq;
       public          postgres    false    224                       0    0    diary_entry_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.diary_entry_id_seq OWNED BY public.diary.entry_id;
          public          postgres    false    223            �            1259    24606 	   favorites    TABLE     �   CREATE TABLE public.favorites (
    favorite_id integer NOT NULL,
    user_id integer NOT NULL,
    recipe_id integer NOT NULL
);
    DROP TABLE public.favorites;
       public         heap    postgres    false            �            1259    24605    favorites_favorite_id_seq    SEQUENCE     �   CREATE SEQUENCE public.favorites_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.favorites_favorite_id_seq;
       public          postgres    false    222                       0    0    favorites_favorite_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.favorites_favorite_id_seq OWNED BY public.favorites.favorite_id;
          public          postgres    false    221            �            1259    16410    products    TABLE     �   CREATE TABLE public.products (
    id integer NOT NULL,
    name_product character varying(100),
    kkal numeric(7,2),
    protein numeric(7,2),
    fats numeric(7,2),
    carbohydrates numeric(7,2)
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    16409    products_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.products_id_seq;
       public          postgres    false    218                       0    0    products_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
          public          postgres    false    217            �            1259    16417    recipes    TABLE     �  CREATE TABLE public.recipes (
    recipe_id integer NOT NULL,
    user_id integer,
    name character varying(100),
    description text,
    image_url character varying(255),
    kkal numeric(7,2),
    protein numeric(7,2),
    fats numeric(7,2),
    carbohydrates numeric(7,2),
    meal_type character varying(20),
    diet character varying(50),
    source text,
    ingridients text
);
    DROP TABLE public.recipes;
       public         heap    postgres    false            �            1259    16416    recipes_recipe_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recipes_recipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.recipes_recipe_id_seq;
       public          postgres    false    220                       0    0    recipes_recipe_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.recipes_recipe_id_seq OWNED BY public.recipes.recipe_id;
          public          postgres    false    219            �            1259    16398    users    TABLE     '  CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50),
    email character varying(100),
    password character varying(100),
    is_admin boolean DEFAULT false,
    protein integer,
    fat integer,
    carbohydrate integer,
    calorie_result integer
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16397    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    216                        0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            i           2604    32789    diary entry_id    DEFAULT     p   ALTER TABLE ONLY public.diary ALTER COLUMN entry_id SET DEFAULT nextval('public.diary_entry_id_seq'::regclass);
 =   ALTER TABLE public.diary ALTER COLUMN entry_id DROP DEFAULT;
       public          postgres    false    224    223    224            h           2604    24609    favorites favorite_id    DEFAULT     ~   ALTER TABLE ONLY public.favorites ALTER COLUMN favorite_id SET DEFAULT nextval('public.favorites_favorite_id_seq'::regclass);
 D   ALTER TABLE public.favorites ALTER COLUMN favorite_id DROP DEFAULT;
       public          postgres    false    221    222    222            f           2604    16413    products id    DEFAULT     j   ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
 :   ALTER TABLE public.products ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    218    218            g           2604    16420    recipes recipe_id    DEFAULT     v   ALTER TABLE ONLY public.recipes ALTER COLUMN recipe_id SET DEFAULT nextval('public.recipes_recipe_id_seq'::regclass);
 @   ALTER TABLE public.recipes ALTER COLUMN recipe_id DROP DEFAULT;
       public          postgres    false    220    219    220            d           2604    16401    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    216    215    216                      0    32786    diary 
   TABLE DATA           x   COPY public.diary (entry_id, date, user_id, recipe_id, name, meal_type, kkal, protein, fats, carbohydrates) FROM stdin;
    public          postgres    false    224   �6                 0    24606 	   favorites 
   TABLE DATA           D   COPY public.favorites (favorite_id, user_id, recipe_id) FROM stdin;
    public          postgres    false    222   �6                 0    16410    products 
   TABLE DATA           X   COPY public.products (id, name_product, kkal, protein, fats, carbohydrates) FROM stdin;
    public          postgres    false    218   �6                 0    16417    recipes 
   TABLE DATA           �   COPY public.recipes (recipe_id, user_id, name, description, image_url, kkal, protein, fats, carbohydrates, meal_type, diet, source, ingridients) FROM stdin;
    public          postgres    false    220   �A                 0    16398    users 
   TABLE DATA           y   COPY public.users (user_id, username, email, password, is_admin, protein, fat, carbohydrate, calorie_result) FROM stdin;
    public          postgres    false    216   �a       !           0    0    diary_entry_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.diary_entry_id_seq', 43, true);
          public          postgres    false    223            "           0    0    favorites_favorite_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.favorites_favorite_id_seq', 75, true);
          public          postgres    false    221            #           0    0    products_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.products_id_seq', 191, true);
          public          postgres    false    217            $           0    0    recipes_recipe_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.recipes_recipe_id_seq', 126, true);
          public          postgres    false    219            %           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 54, true);
          public          postgres    false    215            w           2606    32791    diary diary_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.diary
    ADD CONSTRAINT diary_pkey PRIMARY KEY (entry_id);
 :   ALTER TABLE ONLY public.diary DROP CONSTRAINT diary_pkey;
       public            postgres    false    224            s           2606    24611    favorites favorites_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (favorite_id);
 B   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_pkey;
       public            postgres    false    222            u           2606    24613 )   favorites favorites_user_id_recipe_id_key 
   CONSTRAINT     r   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_recipe_id_key UNIQUE (user_id, recipe_id);
 S   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_user_id_recipe_id_key;
       public            postgres    false    222    222            o           2606    16415    products products_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    218            q           2606    16424    recipes recipes_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (recipe_id);
 >   ALTER TABLE ONLY public.recipes DROP CONSTRAINT recipes_pkey;
       public            postgres    false    220            k           2606    16408    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    216            m           2606    16404    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    216            {           2606    32797    diary diary_recipe_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.diary
    ADD CONSTRAINT diary_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id);
 D   ALTER TABLE ONLY public.diary DROP CONSTRAINT diary_recipe_id_fkey;
       public          postgres    false    4721    220    224            |           2606    32792    diary diary_user_id_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.diary
    ADD CONSTRAINT diary_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 B   ALTER TABLE ONLY public.diary DROP CONSTRAINT diary_user_id_fkey;
       public          postgres    false    224    216    4717            y           2606    24619 "   favorites favorites_recipe_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id);
 L   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_recipe_id_fkey;
       public          postgres    false    4721    222    220            z           2606    24614     favorites favorites_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 J   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_user_id_fkey;
       public          postgres    false    4717    222    216            x           2606    16425    recipes recipes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 F   ALTER TABLE ONLY public.recipes DROP CONSTRAINT recipes_user_id_fkey;
       public          postgres    false    216    4717    220                  x������ � �            x������ � �         �
  x��YYr���>N��ګ��Ð�G��p���	Y���ϠDR�
�����FZ�d��������������/��~���ݲmM�t	�l66,}�8ӿ�W�=L�(b�m�s��6���AǠ'��t�,�	��6�����Ua\�TA�6���l�=�׸l�_-�����
��*�F�@2��~�=5��������
.o��_�D�����QO���ڦ��-^vۯ�gU���D���{~C)��Ī�[����� .������?�L���?��y)�\��$j��8���N�gP���Bm��ж���4֫��X�jꃺ�� N�o����%M��D�OZ���B����>Fǔ2F�ض�]����2�Ʀ�`�U�2�2��DgP��Xu~��7�L�Mt���[�Pzɬ��{������j���U�DG�<��}�T�z�䊥%��"ˇB5�m�����N�]�%���@@�I���M��ny�h��<�?A�3���~��\x�I9��.Q�Dҋ�;�h��&郩�erZ�:�(�
�;��޸n"㙻|��78�D�1����i�P�C/�� j.��|�vu#��#�.�[�׬H��2k�!?o����ƇC���XA�t��K��}A�=L���{E'��}q�/y�=<�fIO<�h��wB�fzFo�r��o:
?U�M��>T��LY�l�MR]y�9�K��Z��"_%�����-\y1&���L��e����Fv��b{(�[;��X�&O��$��8A�������t�dv�|�]-�Ն��X� �?x��u��_�w��8ŽX�L̾& "�?n��۝��P �~@0��(&IN�60�k�$fn�����kc�й�Eu�7��X���T��1�
>xI��7�хAD�  ~0Q��$�ѷ��Ng�}.--&E�(��l;c+���$�������s����te��y�V{��x�&�V�%�����D�8�f\�Y��(�g9E���7��k✤����q����=gx�߅3b��GG�
�1�Et��j�IӟNHC�ޫ�j1����v�B����R���݃m5k�u{e0��5��_}�2�b{^��K1		�؍��'�6�8�9(O�A�����R(�U��ȱ�)6�j��F�eM��;�a���6�e�,� K#�!����R�{��<��f4��e�}]`��9�m`�����0��+��ĚAP���T��s��V�D[��ˀ+�>��`b``L������`�<T��fb`�{�cs\!�&�t���a�k�cTG2��.7Y�Q������,��uẗ́H�&���^<qY��iz�eW��Ċ��NP�{Y�.�e7"�cŚ��Ek����	p#���w�|�~Ϥ�X:bn����8�qܑ��lx� -Q��\K�zY"]��� ��YZ�ę��E�!h�+At��+�N��l8��0���B����p��R��n�{K;�V����f���'9���xQ�Q (�Z*NBo�C�4�{�ͳ����-�;� �X/�����Ċ��
X�h���S��K�zRK�٩t�d[�K�O:�x�mѯ2�Q����C��$_@W�k8��W2�ެRFP��-�c�v�';c�P�Y֨Ws�=I!��c?�:�g���R��
"��ˆ��0SJ�4��Yg|��7v��i��f�K� \�4-�+B^ 
�Z�q�B<��m�u*��R�J�HN��kdı��'��
�U*5OCZ �BXl��#�+y�&��%%��$��%��a��:�[��B9{ؖRR��u�O��x}H,���J�:o@�ŀk�\�)u����X|�(�&oq�x���$�Φ�Y���OBdz�n�?r��'���n��"�>�FƷ�-2�ݻq��nf�u{g���E�FN�8�}��WI��$�7t��D�-V����ϩ�:�h]��}��~6���z�9L2f�6C�N�?ۊO��`nwq0k?#�ԭ��B�EOsEW�+6�J>����x�O$G3��#U�a8������B`�G�صc�qM���� ����Lث`�������7�N�����N��]�yxȏ�<H�x�(���BIQ%�^�)J�￮'��g�����D��*�I�83�2�2�
�>����3�t����y7_K����vÍ�)�˾%��ߑ��׆l�a�r2xm$Ϫ�*��Őq3hw�<Ɯ�7�K~g�dCz���4;���:
U�(�{�/�(���r:$v�E'�(uC��`	��Z>��ZW�^��{VнB��nʙ����K�畦n��5rn�
�x��ο�Xτ6����]�rm^'���A�=��M�ՌJ�)]�gX8��<� ��4ά�ܒ�92��8oe��j�0���q|�@Az��ql_��=�sY43�K�f�Vc��<v�i�&iS����$�='�ޭT���me�en����y[r7�Wo��'-�V8�G�6[�	C�6�|H�M���ڃ��7Z2:D���>N��
P'w2�_#�l��Z�G�ڜ�z0?� ����<���<�-��p[���|�,�������a�3���a�l:�IÒq��MÒHz�V��;i�� WPRH�����H���өD?Y�I����FWWG�lg�o��V(�	��_'�$#��M��/ ��            x��]�rgv����/�*4����E*�L�|Q��"T$%�犋er"��Ny��&e237SABl� X5O ��<I���k7ғJ�M��������A�,}��K�_�g���hr<N^������#.t&��WO|�?�M^�k�q��&_M��}���-����'��Ş79�W��F��B�r=y���5�r&�����s�+qK�!��&�V��O�61��t@����Z�����qG�q#�r �s#���k1�xX�������x#ƃĿ'bf�v��x���������z�|����A��0O��z��a��AG�ʓg���z}�^_J�G����sw�������qs瓝���%ߓ������LW>��t[|�ʹ��.6�o���#�Ih|�^lm�q ���8���t���ho�Q�`�H1y�|/"d�o�;����b;�H�B�Zl���#H2�M�x��z𿸧 "7�5q��Z̓-���ā�0�3q;�?��������'�'.�
� UĽC�Rآ��<@N��`b�K�[�t*n���qpB�,X����Ԧ%!	杼�9o.�=��53�<.7G��.�u��'s#�\�Ey����y=��8'��cd�(��[Ϸ�6�^�?^�k�K{{�vW<X�\�y�`g}m���ڻ���_����x����Qs��(��Iꉟ��ƝU/KWy3̟5!W���]�d9O@u�E�+���׫1Y�z �C>�� �9wu�/�y8�Gc��Q)�x�5���b�	�I�s��J)��W����WL�髲g���L��-�^$�>O�Z���� Q��FblX,B���顸��䨬�Q��R�|�&�Vjy!OoQ<���'o@i{JQ�K-{&!vS<��kԀ55���K�N=��s��{�>.����@X�s�x1#��|/��Ұו�ѿB,�E�Қ��5�7؄0\2�9�̋i��:���B����"d��pG�n��G�(N�0��4H�8o4P�I]&�Q��N[�������i�y��$f�n��q�ALĖ���� ��~4���k��� ��j�d���͠��Z��zx�SnY�'1F�Z��xhdI m$9$��[���&U�a0��)����}�T��{�@�}�,����c��?����q���kP�Gl�Op;�ٳ�J�dN�BKĨ%~bS���� y�5y���S�A[ch�"��+�3Ȼ��.�|��9I���f+����E���x�t�>z�
FO8:+�`ܰ�t/���o\��z�w��b��~��w���9G]׆Z�sG�#9yA��_�N��U��Zk%!*%a��F��FdY=��(����!�$��5<[�]k�� ��Gd��=Y���͔�9�A1���Ah}��C����h�t-��)2�t�Yd�<���O�A��k:`�DoI�5L���z�"��� �ZH�Gx����}2�4r�P��v�nD��D�B�)���k2���p�S���0��e7����b�i�t���c�V���z��~,86� 1���/<jmo��8AS).|��g�P����26��Y�;�Ղv�p���8β�JŎ������ʷY����Z.�ޟ+l�������|�������+t��������\(�'�.s��'��3��U�Vrߌ��1���6%���DҾĘ�BڟE� ʄ�l�Y���(������
�����zs���^U���矯4��D��Jye����� ��z��g;�[{�ns���������~�|g��R�أZi����N�����I�a��}$�G���W��a��O}��x��D}y�d���L�qGp��U�q|���	��k��[h��qb����9PC� �1��:���R��:��=E�K���K���r��
d%8p���5�y���g���@!j���=bs]�+��7���<�]9���kG�#��?^c���Mp	���p]K��Is"	Q��Wu�"�>�q	�JtŃ0���.�?=�*�#A�7�A�
Ԩ�JtxOh��ɩ�?i�<��@&���=f�.1���}��7���Ĺ�UΙL�-�iT��^G�$>	�jrX�!?�o�
u�� �h�(�X�!P��6d;г�
�7�6n�>FH}-ߛ�cƔ��% ,2&��P��g�LV�hg�Ⴑ~�/h�4�t�[����x�nH��\i
���T��\ 𦊊$�w�|�@
��̯\��$Yf�/~��4n����s��H�������bo���z�~�����|��7��M��|���l?�7El���ď�y.����V�t+�C�gr*�c�v\�]�^�R��'$J�g(��Q��գ+�ˆ�ԧ�K[�����Zb���Ky��?��-�}Ջ��pn�	��cL���¹�3�G}�ڙ�0�0�%�)!���P �>"|�1tv�q`T�����Y2D��H7�����ޗ����~!Cp�1Xe���a> t�@3�c��0��G>:�8#Hy�c2�O��O?�.9l�;�XM�'�w!{�.��G��� �b_���#�.S����c"�����j���g2���L��� q�a�I��>/xŚ�'��eRC�E����$t�j�4ꍺ�7A�GY��.��*��K�;+��Ϸ�k����^�wڏ��k�ho6��0�h9K�V��1Ƣ�m,?O�*�3[o0���#58��w�� d�j�l��b��L��A)�
��5�e�Î�Q�Y�[�J����	�ٻ/L���� ��2�K|����窌��Y�(8��n���#��^$�p=*!}DP@�P9^I�|����f*r�&�"3!���z`�L���o��������3܊sDʹ*���ߢR>�|���}��̘�k�y��!�p ��v�H��K��2����p1-�&��kGm� &��(̈j��3���=or����(�3�,y�q��	��\)X�ŏbB�"���������!�Yb9�[���jz�m�z* k��>�5Cr�\��c�*�-��� �',�8����qg[e����!a��ؠ.�$&=���TGd:U��b�#�eG�� >2��t.ᅇ\a`8(��@��x�P<�Ul'���c��K�1`t��!E�4E�qT�,5�(tN�(/���C�zgG��(7(�*r���H.�m*
����`
�+��?��?ˣF���$nDa�S�0�����0�N����l6w7�����Z��n���������|��0ʣ�9���&�g�9p����-NĠ�Dإ�j��=G����*���l�����AkS	L.���yy3�U^��N�	�K�:�41�I#N�Yo�	�[���.̽A�f^P7��n!�G��{���;�3�
X����;B�ԩ���Sm�{���f�XD���ɗ��&XێYТ�Ȉ��ׅ�8�����TU���!���H�B甹!('��C�����.*�s� �j��;��:@�i����X'\��&�I���'��]�XK&�d`��'o׎��A.��vT��Zy2����/=#��,C'q���H��p�g'jU͘Ll�[� �F�H��ODh6 *��R�/N�fw׭����fK�����^������~ �z��<��7��d�R����c)V����4��E��i�9J�A�YJV���Ke���gV���&ʟ�����/�I&>�<.�a�u�3|���!c�n�%U��F9��J����S_�e��J7�GCb&GJq��ٻR+��z�.��r
[�T�w(ʂn����D�\Έ�N�AVlvI��R�աpF����25�IQ�78�B����G�r
���e���ܬ���4C����A5� Έ�6g���I߁���8o�'�0����@7msZ�̢V��ݛ���a��+��4~@|}�->@S����q�!�W��Fr���R)&(��H��tt?A����c��b��x���1�,��t��0SG˧�:���B��I�׹�!I�~Q��9�n�������'�n��    �Z�ͽ�S?J!:�c*�\	n]��j�X����6�㵚��@��~�~�N1{�*�5����F�-t���:U�s��ե .�Ty��өP��d�χ�������~(��m��N�u�(��MV._�h}�����]��g%��@V)�(p�j#hU��j~�xL�:�P �C����,�= ��I�cDL\�%X�R]a4od$�Ș~&g����mǬ�O,��� �	T�i��U�	Hj��~�s�$���@3Ϲo�T#�-�59nŁ�M���xI�S���N�\�Ę������ыx��c�o�� �yg�So(��URH#g@)fс�V`�g&�:5�l@�s"�˪���K��
�^ �c�a��~�kKV���'@a�PLh�w���7�8��)vX�Ǫڔp*�u�R�J�h�&�%c�l����:&��̄).3rX��շe0����_C�j�k�i�-L<��Ё���4<`�s�.Q/�d0�~Ğ����Cܨ����~UC�0�Qp`jWZ�9Kg���S+�[<z3�����I��\�����*'�v��̊ O�ʈ�)������8��߳�r�1DY3�B�
��@u+I]YC���$ƩJx�����GWı�p&��K��|T0l�<q!w���C�HU����#��9�,��*�H�� ��DL+Csb����v�X%��./w�p�N֙P=�r��w4�
�ʚ��.�h	1{rH�<d��O������<��>A��'d�����(����G��~�i#�s:�42UI���Ύ�ݍ�m�f���|����~��6_��0�S7XtET���f;�FA�t�kZB�(XՇ����삛г�_�p&g�L�,n:��f��&h8"�V��P��W�GHz*���E��O�ݕ�����9��l�J���׆�х�3p�%%���$�̡%�@W9m?���5�^���:Y��'��+��{���d�d%��9�L/q����3FB�R1��̥Ue��^�>�~Ƨ$�q%q�7�,�Su,AQ@u��	�E�r����J���~�C1�Z��̇;_l����$Ae��Q�\q�Gsx��0�%;N��3>��1�ddvXZ���6m4�C���U]�j�e��~Y!t`��Џ�I���3�� �Q�K�`��U(��&f@�LĄX�@�S}h����Fʒ�#	I�n��hJ��7�\P� 5\���E�|���9r;'�e��6�ҷT�;R��)�N��>��O�ѳϤw�@J9���
�~Jy�[w.}��]9w�� ,İ�]
�3�H�ax�
y��L�݁Q�W.翲T4��W�o�#����0��0͂,�g�>�Z���WD��(���0�¨�d������)TI�GT�EE�s��L3����/��01�x�1z��J�����x��:��Ko��&&�
��� Mxɂ�<�9��ʉ[^����$��؎����t·�={���,�U]�uWȷ�H�e��6 {7U��Y�JH���|���\k�
�V�>�����j`w�4�.���-/va��2��8�t��m	.	m��y�Q#ҠdT��*��w�X.΀��nk���_�X����t1P���z��u�j����)J����nPb��}�X;�u9BY����;���:0K��W����
۝�zn�0eCFX�*�h�J'���cl�h��<|d逪Qv�I��E�lEC�9GL8j6kݬ#�
&�U�D"1>#�Zy${F2�:f���[� �
�I[�vX��q\Ǝ��l`r��Ӻ���,����k��&,��P�g"�*��NC���L�����L�ru��$�Q-Hͮ�����̄J'4Y�ǲ|E~��1i7� (��(*`�c���H�_c��I��r�\y�#��<T��H)�Ӓ�S�"�򍂠܂\;~4o%FT���eW%ƙFc��k`;���h���YY=�V1e.�>�Nkg���f{ok}��?m�o���q��&�j"���k!lE%d3M�w�K�Ԙ�'�©�i��S�"�7��eT�j�f0��n!�
�T��:�$�M�$z�J�<�nG��d� h�;d?�6 ����u��'Fc�Ʀv�89�nߠH=�
>*{�:)P3�ΙEuh��j��K�ۚ�ig��ܿ}Ey�++�tX��mJm��GR��c*�?�,K��!�(
\�PWp7J���өD������������۬ڽu�#Cz��_��4���=p{��@��J0��,��r*[~����UfW��(�D�z+�	17[�NoO��k�`�OT_p{b)��gt��<_�6j�y���h�R�c{��Y� �s?
��QS����A�d�����iﭷ���#��������}U�Wͧ�c��"�}ğ�b�l5y��N"��M��x������ܾՈ�EtT��U�|�u��|�������s+�g��c���-Uu(�v3,Łn�-��s�5'���9��&�MG���
�c����sy�L�G��k�o�`�H ވ�cMB��&JQ�*��jgFMx.��eFl�e./r�s��TyTT&ܳ�ts��̈́��C��Ō�3�e+h-��H�2lXxg���,�]r�s�$A��ú�OA�������6�q�%��d]���j>j����g���֓�~�H���#����
�mV�]ur�eC�aj�ȏ���6�N��v\�N��K�<��eT���}<\uQ�7�E�6}`��H��%�������K�^�~^�)�R��u�R���6:��а�"L$g����y9Jq:�CC��}t�󧲫洓�����������5h2�C��h�<,W�`@��M`8�_!b��	W;��2G�})m/�������)s*�2��X����#Bb��:�~����RpN�Օ�f�|���>}�������!ͩ��(b`J���Y�\�jW�r��?�e�E><9����&k�9A)�1��#�c>1�ש����P��].:{�y��'aP�T����x�΂kf���w�>7�dљ�#[�N�r�Ι��l5ͫ� ����#R3~hKآz��h<���ſ�ܰX.�R��gt��eg�:�vad�D��,z�`(Ki��~#hQE&@��i�Fp���Kw��?�4ϻ���!	h��5+����y�e��A�J!k֝�e�t�v�n֖��CԱ�Xx����J���W"�����w��'�y
'۰ʦ�cny�TQa� �Qш����?X��)��:�.~b�tx��:C�]�m�o��]D�ٽ�&����w�vSe��;6�,�ʨ	�,L��|���3s�Y�5Q��y�����r&lC9�T��PY[���Gb��"�s{κ}�o��f�U.�ۭ����tBI�)O�J�%�i���*�;�#���K��y�e����hm����u�C?Y��2���ө���p3��u^�y �RԧĹ�s��V������ҏ4JKn�D���jw�~쳋VK�dnl�j��Gy�c�����<uP�F&D<ͳ��ƻI��f����f�'}����%�$TM��-[��Ir�Ā:�INg��P�	�āh���\5���=���v�K����.��z�
Mɪ�,s�X��2TOj����tǀ�0��:Su����ps��z*ȗ�q�A�Y�aJbǈ ��I�p~	�VۄѾ2��Ӧ����#�I�]��ikأ}�H���b��.�������r�wE5*�^fl6w:%I�;n>Z2���|�3`9�� U�4���a�q���uf�L�-J<$iž��(�gQjj��eR�׶֛����km?&m����?`�>�edn
`|��rѯU57��3��u���Z.������R�[~;�"�A���SU���n���F8f߭A:�Ұ��n\�W��U��[�4���^�����/�� �b?�\ql����"=�����^{�/)1���$Sy����Τ�RJ_si��F���}GO�#[f�2�L�wd�efw瓊s��PDs��+*��&��|9tG�s!�qͻM�R�b̼�p0?i�ټ75L(\VԘWdʎr.W��v��/���Qu�p�ާ+����_;I��         �   x�35�0�{.츰����.6\�p��¾��E��%���9zE��*FI*�*��i&�iIzNŮ�e>��f�٥�f��QU�ni�A����&�QF�azYe&iEF��%�&&�&f������F\�&��_�wa�Şہ�&��[A|����"tk��M-�C�����*��+=K��S|3����ˍ�"���=ӂ󊋲�=�9�Э����� ��Z�     