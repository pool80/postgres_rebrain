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