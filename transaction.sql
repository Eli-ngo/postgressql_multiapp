-- Active: 1684762799193@@127.0.0.1@5432@multiapp
BEGIN;

INSERT INTO forum.forum (title, user_id, description) VALUES
('Blabla', 2, 'Mouai');
UPDATE forum.forum SET title = 'hehe' WHERE id = 1;

SELECT * FROM forum.forum;

SAVEPOINT my_savepoint;

INSERT INTO forum.forum (title, user_id, description) VALUES
('Blabla', 2, 'Mouai');

ROLLBACK TO my_savepoint;

SELECT * FROM forum.forum;
COMMIT;

END;