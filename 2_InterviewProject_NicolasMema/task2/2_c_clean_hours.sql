ALTER TABLE hours
ADD user_id int
    CONSTRAINT FK_hours
    FOREIGN KEY (user_id)
REFERENCES users(user_id)
ON DELETE CASCADE ON UPDATE CASCADE
GO

DELETE FROM hours
WHERE userid > 1324
GO

UPDATE hours
SET user_id = userid
GO

ALTER TABLE hours
DROP COLUMN userid
GO
