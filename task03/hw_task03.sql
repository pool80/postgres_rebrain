psql -d rebrain_courses_db -c 'SELECT *, sum(price) OVER () FROM courses;' -o /tmp/answers/devops_old_price

UPDATE courses SET price = '100000' WHERE coursename = 'Devops';

psql -d rebrain_courses_db -c 'SELECT *, sum(price) OVER (ORDER BY price) FROM courses;' -o /tmp/answers/devops_new_price

CREATE TABLE auditlog(
id SERIAL PRIMARY KEY NOT NULL,            			-- Primary Key
user_id INT NOT NULL,                  				-- id пользователя, который был создан
creation_time timestamp NOT NULL DEFAULT now(),     -- время создания записи о новом пользователе
creator varchar(50) NOT NULL DEFAULT session_user  -- имя пользователя базы данных, с помощью которого производился insert
);

SELECT user_id,record_date,user FROM users;

CREATE FUNCTION fnc_auditlog_users_insert() RETURNS trigger AS $insert_into_users_trigger$
    BEGIN
        INSERT INTO auditlog(user_id) VALUES (NEW.user_id);
        RETURN NEW;
    END;
$insert_into_users_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER insert_into_users_trigger AFTER INSERT ON users
    FOR EACH ROW EXECUTE FUNCTION fnc_auditlog_users_insert();


INSERT INTO users(username, email, mobile_phone, firstname, lastname, city, is_curator)
VALUES ('kinder', 'kinder.surprise@gmail.com', '+11111111111', 'Kinder', 'Surprise', 'NULL', 'false');


CREATE VIEW get_last_10_records_from_auditlog AS
SELECT * 
FROM auditlog 
ORDER BY creation_time
LIMIT 10;


Задание:

1. Установите postgresql v13 на предоставленной VM c OS Ubuntu 20.04.
2. Добавьте в PostgreSQL пользователя root c правами SUPERUSER.
3. Создайте базу данных "rebrain_courses_db".
4. Для работы с базой данных создайте пользователя "rebrain_admin".
5. Выдайте все права пользователю "rebrain_admin" на базу данных "rebrain_courses_db".
6. Переместите файл бэкапа базы данных "rebrain_courses_db" из предыдущего задания на сервер и положите в директорию `/tmp/` с именем `rebrain_courses_db.sql.bqp`.
7. Восстановите данные из бэкапа базы данных из предыдущего задания командой:
psql -U root -d rebrain_courses_db -f /tmp/rebrain_courses_db.sql.bqp


8. C помощью утилиты psql, подключитесь к базе данных "rebrain_courses_db".
9. Проверьте наличие данных в таблицах, чтобы понять, что бекап данных прошел успешно.
10. Посчитайте общую стоимость практикумов компании REBRAIN из таблицы courses с помощью оконной функции `sum(price) OVER ()`, результат сохраните в файл `/tmp/answers/devops_old_price` (используйте запрос SELECT * FROM ...).
11. Обновите данные цены практикума в таблице №2 для практикума "Devops". Новая цена: 100000 руб.
12. Посчитайте общую стоимость практикумов компании REBRAIN из обновленной таблицы courses с помощью оконной функции `sum(price) OVER (ORDER BY price)`, результат сохраните в файл `/tmp/answers/devops_new_price` (используйте запрос SELECT * FROM ...).
13. Добавьте новую таблицу auditlog с NOT NULL полями:
- id (PrimaryKey)
- user_id (id пользователя, который был создан)
- creation_time (время создания записи о новом пользователе)
- creator (имя пользователя базы данных, с помощью которого производился insert)
14. Создайте функцию c именем "fnc_auditlog_users_insert", которая логирует в таблицу (записывает в таблицу) auditlog информацию о регистрации нового пользователя на сайте компании REBRAIN.
15. Создайте и установите триггер "insert_into_users_trigger" на INSERT данных в таблицу users так, чтобы вызывалась функция c именем "fnc_auditlog_users_insert", которую вы создали выше.
16. С помощью команды INSERT, добавьте в таблицу "users" 15 новых пользователей. Для каждого нового пользователя делайте отдельный запрос, так чтобы срабатывал установленный триггер.
17. Создайте представление c именем "get_last_10_records_from_auditlog", которое позволит вывести из таблицы auditlog последних 10 попыток записи в таблицу users за последний день с сортировкой по времени (select * from auditlog limit 10 сортировка по времени).
18. Сделайте бекап базы с помощью команды:
pg_dump -U root rebrain_courses_db > /tmp/rebrain_courses_db_task03.sql.bqp


19. Если уверены, что все выполнили правильно, оправляйте задание на проверку.