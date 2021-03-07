CREATE ROLE root WITH LOGIN SUPERUSER PASSWORD 'postgres';

CREATE ROLE "rebrain_admin" WITH LOGIN  PASSWORD 'postgres';

CREATE DATABASE "rebrain_courses_db";

GRANT ALL PRIVILEGES ON DATABASE "rebrain_courses_db" TO "rebrain_admin";

\c "rebrain_courses_db"

GRANT ALL PRIVILEGES ON SCHEMA public TO rebrain_admin;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rebrain_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rebrain_admin;


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