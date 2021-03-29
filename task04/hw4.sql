--Добавьте в PostgreSQL пользователя root c правами SUPERUSER
CREATE ROLE root WITH LOGIN SUPERUSER PASSWORD 'postgres';

SET ROLE root;

--Создайте базу данных "rebrain_courses_db"
CREATE DATABASE "rebrain_courses_db";

--Для работы с базой данных создайте пользователя "rebrain_admin"
CREATE ROLE "rebrain_admin" WITH LOGIN  PASSWORD 'postgres';

-- Восстановите данные из бэкапа базы данных из предыдущего задания командой:
psql -U root -d rebrain_courses_db -f /tmp/rebrain_courses_db.sql.bqp

--Выдайте все права пользователю "rebrain_admin" на базу данных "rebrain_courses_db".
GRANT ALL PRIVILEGES ON DATABASE "rebrain_courses_db" TO "rebrain_admin";
\c "rebrain_courses_db"
GRANT ALL PRIVILEGES ON SCHEMA public TO rebrain_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rebrain_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rebrain_admin;

--отзыв прав на схему 
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SCHEMA public FROM rebrain_admin;
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON  ALL TABLES IN SCHEMA public FROM rebrain_admin;

-- Создайте роль backup
CREATE ROLE backup WITH LOGIN PASSWORD 'postgres';

-- С помощью команды GRANT USAGE выдайте права на использование схемы public пользователю rebrain_admin.
GRANT USAGE ON SCHEMA public TO rebrain_admin;

-- Затем, с помощью команды ALTER DEFAULT PRIVILEGES выдайте для роли backup права SELECT на вновь создаваемые таблицы пользователем rebrain_admin в схеме public.
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO backup;

-- Зайдите под пользователем rebrain_admin в базу данных rebrain_courses_db:
SET ROLE rebrain_admin;

-- Cоздайте таблицу blog в базе данных rebrain_courses_db:
CREATE TABLE blog(
id SERIAL PRIMARY KEY NOT NULL, -- Primary Key
user_id INT NOT NULL, -- Foreign Key to table users
blog_text TEXT NOT NULL,
CONSTRAINT fk_user_id
FOREIGN KEY (user_id)
REFERENCES users(user_id)
);

-- Занесите следующие данные в таблицу blog:
INSERT INTO blog(user_id,blog_text)
VALUES (1,'We are studying at the REBRAIN PostgreSQL Workshop');

-- Снова подключитесь пользователем root к базе данных rebrain_courses_db.
SET ROLE root;

-- Создайте роль rebrain_group_select_access.
CREATE ROLE rebrain_group_select_access WITH LOGIN PASSWORD 'postgres';

-- С помощью команды GRANT USAGE выдайте права на использование схемы public пользователю rebrain_group_select_access.
GRANT USAGE ON SCHEMA public TO rebrain_group_select_access;

-- Выдайте права для rebrain_group_select_access только на SELECT из всех таблиц в схеме public.
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rebrain_group_select_access;

-- Создайте роль rebrain_user.
CREATE ROLE rebrain_user WITH LOGIN PASSWORD 'postgres';

-- Выдайте для роли rebrain_user права роли rebrain_group_select_access
GRANT rebrain_group_select_access TO rebrain_user;

-- Убедитесь, что роль rebrain_user может получать все данные из любых таблиц базы данных rebrain_courses_db в схеме public.
\du

-- Создайте роль rebrain_portal.
CREATE ROLE rebrain_portal WITH LOGIN PASSWORD 'postgres';

-- Убедитесь, что вы подключены к базе данных rebrain_courses_db. Для базы данных rebrain_courses_db создайте новую схему rebrain_portal.
CREATE SCHEMA rebrain_portal;

-- Спомощью команды GRANT USAGE выдайте права на использование схемы rebrain_portal пользователю rebrain_portal.
GRANT USAGE ON SCHEMA rebrain_portal TO rebrain_portal;

-- Выдайте все права на схему rebrain_portal для роли rebrain_portal.
GRANT ALL PRIVILEGES ON SCHEMA rebrain_portal TO rebrain_portal;

-- Сделайте бекап базы данных rebrain_courses_db с помощью команды:
pg_dump -U root -h 127.0.0.1 rebrain_courses_db > /tmp/rebrain_courses_db_task04.sql.bqp
