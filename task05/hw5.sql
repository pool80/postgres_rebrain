1. На сервер Postgresql-Ubuntu18 из официальных репозиториев Ubuntu установите СУБД Postgresql версии 12.
2. Добавьте в PostgreSQL пользователя root c правами SUPERUSER.
3. Создайте БД rebrain и пользователя с именем extuser.
4. Установите расширение pg_cron для Postgresql-12 c помощью пакетного менеджера apt.
5. Настройте очистку (VACUUM) ежедневно в 2 часа ночи для БД rebrain с запуском от имени пользователя extuser.
6. Если уверены, что все сделали правильно, сдавайте задание на проверку.


sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql-12

--Добавьте в PostgreSQL пользователя root c правами SUPERUSER
CREATE ROLE root WITH LOGIN SUPERUSER PASSWORD 'postgres';

--Создайте базу данных "rebrain"
CREATE DATABASE "rebrain";

--Для работы с базой данных создайте пользователя "extuser"
CREATE ROLE "extuser" WITH LOGIN  PASSWORD 'postgres';

-- Install the pg_cron extension
sudo apt-get -y install postgresql-12-cron

-- run as superuser:
CREATE EXTENSION pg_cron;

-- optionally, grant usage to regular users:
GRANT USAGE ON SCHEMA cron TO extuser;

SELECT cron.schedule('0 2 * * *', 'VACUUM');