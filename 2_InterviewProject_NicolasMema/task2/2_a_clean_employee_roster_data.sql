CREATE TABLE users (
    user_id int NOT NULL IDENTITY(1,1),
    fullname varchar(100) NOT NULL,
    gender varchar(10),
    email_id int NOT NULL UNIQUE,
    PRIMARY KEY (user_id)
)
GO

SET IDENTITY_INSERT users ON;
INSERT INTO users (user_id, fullname, gender, email_id)
SELECT user_id, fullname, gender, email_id FROM employee_roster_data ORDER BY user_id ASC;
SET IDENTITY_INSERT users OFF;
GO

--------------------------------------------

CREATE TABLE title (
    title_id int NOT NULL,
    title_name varchar(100),
    PRIMARY KEY (title_id)
)
GO

INSERT INTO title (title_id)
SELECT DISTINCT title FROM employee_roster_data ORDER BY title ASC
GO

--------------------------------------------

CREATE TABLE currency (
    currency_id int NOT NULL IDENTITY(1,1),
    currency_name varchar(5),
    PRIMARY KEY (currency_id)
)
GO

INSERT INTO currency (currency_name)
SELECT DISTINCT currency FROM employee_roster_data ORDER BY currency ASC
GO

--------------------------------------------

CREATE TABLE region (
    region_id int NOT NULL,
    region_name varchar(100),
    PRIMARY KEY (region_id)
)
GO

INSERT INTO region (region_id)
SELECT DISTINCT region FROM employee_roster_data ORDER BY region ASC
GO

--------------------------------------------

CREATE TABLE office (
    office_id int NOT NULL,
    office_name varchar(100),
    PRIMARY KEY (office_id),
    region_id int FOREIGN KEY REFERENCES region(region_id)
)
GO

INSERT INTO office (office_id, region_id)
SELECT DISTINCT office, region FROM employee_roster_data ORDER BY office ASC, region ASC
GO

--------------------------------------------

CREATE TABLE department (
    department_id int NOT NULL IDENTITY(1,1),
    department_name varchar(100),
    PRIMARY KEY (department_id),
    office_id int FOREIGN KEY REFERENCES office(office_id)
)
GO

INSERT INTO department (department_name, office_id)
SELECT DISTINCT department, office FROM employee_roster_data ORDER BY department ASC, office ASC
GO

--------------------------------------------

ALTER TABLE employee_roster_data
DROP COLUMN email_id, fullname, gender, office, region
GO

--------------------------------------------

ALTER TABLE employee_roster_data
ALTER COLUMN user_id int
GO

ALTER TABLE employee_roster_data
ADD FOREIGN KEY (user_id)
REFERENCES users(user_id)
ON DELETE CASCADE ON UPDATE CASCADE
GO

--------------------------------------------

ALTER TABLE employee_roster_data
ALTER COLUMN title int
GO

ALTER TABLE employee_roster_data
ADD FOREIGN KEY (title)
REFERENCES title(title_id)
ON DELETE CASCADE ON UPDATE CASCADE
GO

--------------------------------------------

ALTER TABLE employee_roster_data
ADD department_id int
    CONSTRAINT FK_department
    FOREIGN KEY (department_id)
REFERENCES department(department_id)
ON DELETE CASCADE ON UPDATE CASCADE
GO

UPDATE a
SET
    a.department_id = b.department_id
FROM
    employee_roster_data AS a
    INNER JOIN department AS b
        ON a.department = b.department_name

ALTER TABLE employee_roster_data
DROP COLUMN department
GO

--------------------------------------------

ALTER TABLE employee_roster_data
ADD currency_id int
    CONSTRAINT FK_currency
    FOREIGN KEY (currency_id)
REFERENCES currency(currency_id)
ON DELETE CASCADE ON UPDATE CASCADE
GO

UPDATE a
SET
    a.currency_id = b.currency_id
FROM
    employee_roster_data AS a
    INNER JOIN currency AS b
        ON a.currency = b.currency_name
GO
