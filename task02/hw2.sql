--Добавьте в PostgreSQL пользователя root c правами SUPERUSER
CREATE ROLE root WITH LOGIN SUPERUSER PASSWORD 'postgres';

--Для работы с базой данных создайте пользователя "rebrain_admin"
CREATE ROLE "rebrain_admin" WITH LOGIN  PASSWORD 'postgres';

--Создайте базу данных "rebrain_courses_db"
CREATE DATABASE "rebrain_courses_db";

--Выдайте все права пользователю "rebrain_admin" на базу данных "rebrain_courses_db".
GRANT ALL PRIVILEGES ON DATABASE "rebrain_courses_db" TO "rebrain_admin";
\c "rebrain_courses_db"
GRANT ALL PRIVILEGES ON SCHEMA public TO rebrain_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rebrain_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rebrain_admin;

--Руководствуясь инструкцией к заданию, создайте необходимые таблицы, внесите в них исходные данные. Помните, что каждой таблице присвоен свой виртуальный номер, чтобы в дальнейшем проще понимать к какой таблице нужно обращаться.
-- Таблица №1. - users
-- Таблица №2. - courses
-- Таблица №3. - users__courses
CREATE TABLE users(
    user_id SERIAL PRIMARY KEY NOT NULL,             -- Primary Key
    username varchar(50) NOT NULL,                   -- Имя пользователя
    email varchar(50) NOT NULL,                      -- Электронная почта
    mobile_phone varchar(12) NOT NULL,               -- Номер телеона
    firstname TEXT NOT NULL,                         -- Имя
    lastname TEXT NOT NULL,                          -- Фамилия
    city  TEXT,                                      -- Название города
    is_curator boolean NOT NULL,                     -- Является ли пользователь куратором
    record_date timestamp NOT NULL DEFAULT now()     -- Время создания записи о пользователе
    );

CREATE TABLE courses(
    course_id SERIAL PRIMARY KEY NOT NULL,  -- Primary Key
    coursename varchar(50) NOT NULL,        -- Название практикума
    tasks_count INT NOT NULL,               -- Количество заданий в практикуме
    price INT NOT NULL                      -- Цена практикума
    );

CREATE TABLE users__courses(
    id SERIAL PRIMARY KEY NOT NULL,     -- Primary Key
    user_id INT NOT NULL,               -- Foreign Key to table users 
    course_id INT NOT NULL,             -- Foreign Key to table courses 
    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id) 
            REFERENCES users(user_id),
    CONSTRAINT fk_course_id
        FOREIGN KEY (course_id) 
            REFERENCES courses(course_id)
    );

-- Внесите информацию о новом пользователе в таблицу №1:
INSERT INTO users(username, email, mobile_phone, firstname, lastname, city, is_curator)
VALUES ('vladon', 'Vladislav.Pirushin@gmail.com', '+79817937545', 'Vladislav', 'Pirushin', 'NULL', 'false');

--Внесите информацию о новом курсе "Postgresql" в таблицу №2:
INSERT INTO courses(coursename, tasks_count, price)
VALUES ('Postgresql', '14', '7900');

--Внесите в таблицу №3 данные о том, что пользователь c номером мобильного телефона "+79991916526" купил практикум "Devops".
SELECT * FROM users WHERE "mobile_phone" = '+79991916526';
SELECT * FROM courses WHERE "coursename" = 'Devops';
INSERT INTO users__courses(user_id, course_id)
VALUES ('3', '6');

--Получите все данные из таблицы №2 c информацией о курсах, результат сохраните в файл `/tmp/answers/table2_courses_data`.
SET ROLE root;
COPY courses TO '/tmp/answers/table2_courses_data';

psql -d rebrain_courses_db -c "SELECT * FROM courses;" -o /tmp/answers/table2_courses_data

--Получите из таблицы №1 список имен пользователей (username) и их мобильных номеров (mobile_phone), 
--результат сохраните в файл `/tmp/answers/table1_usernames_and_phones`.
psql -d rebrain_courses_db -c "SELECT username, mobile_phone FROM users;" -o /tmp/answers/table1_usernames_and_phones

--Удалите все данные из таблицы №1, связанные с именем пользователя "yodajedi".
DELETE FROM users WHERE "username" = 'yodajedi';

--Обновите данные пользователя "Vladislav Pirushin" в таблице №1 указав, что он теперь является куратором.
--Обновите данные цены практикума в таблице №2 для практикума "Postgresql". Новая цена: 10000 тыс. руб.
UPDATE users SET is_curator = 'true' WHERE username = 'vladon';
UPDATE courses SET price = '10000' WHERE coursename = 'Postgresql';

--Используя LEFT OUTER JOIN получите всю информацию (SELECT *) из таблицы №2 и таблицы №3, 
--результат сохраните в файл `/tmp/answers/LEFT_OUTER_JOIN`.
COPY
(SELECT * 
FROM courses AS A
LEFT OUTER JOIN users__courses AS B
ON A.course_id = B.course_id)
TO '/tmp/answers/LEFT_OUTER_JOIN';

--Используя RIGHT OUTER JOIN получите всю информацию (SELECT *) из таблицы №1 и таблицы №3, 
--результат сохраните в файл `/tmp/answers/RIGHT_OUTER_JOIN`.
COPY
(SELECT * 
FROM users AS A
RIGHT OUTER JOIN users__courses AS B
ON A.user_id = B.id)
TO '/tmp/answers/RIGHT_OUTER_JOIN';

--Сделайте бэкап базы данных командой:
pg_dump -U root rebrain_courses_db > rebrain_courses_db.sql.bqp