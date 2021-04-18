CREATE TABLE skill_group (
    group_id int NOT NULL IDENTITY(1,1),
    attribute_group varchar(100),
    PRIMARY KEY (group_id)
)
GO

INSERT INTO skill_group (attribute_group)
SELECT DISTINCT attribute_group FROM skills ORDER BY attribute_group ASC
GO

--------------------------------------------

CREATE TABLE skill_subgroup (
    subgroup_id int NOT NULL IDENTITY(1,1),
    attribute_subgroup varchar(100),
    PRIMARY KEY (subgroup_id),
    group_id int FOREIGN KEY REFERENCES skill_group(group_id)
)
GO

INSERT INTO skill_subgroup (attribute_subgroup, group_id)
SELECT DISTINCT a.attribute_sub_group, b.group_id
FROM skills AS a
INNER JOIN skill_group AS b
    ON a.attribute_group = b.attribute_group
ORDER BY a.attribute_sub_group ASC, b.group_id ASC
GO

--------------------------------------------

CREATE TABLE skill_name (
    name_id int NOT NULL IDENTITY(1,1),
    attribute_name varchar(100),
    PRIMARY KEY (name_id),
    subgroup_id int FOREIGN KEY REFERENCES skill_subgroup(subgroup_id)
)
GO

INSERT INTO skill_name (attribute_name, subgroup_id)
SELECT DISTINCT a.attribute_name, b.subgroup_id
FROM skills AS a
INNER JOIN skill_subgroup AS b
    ON a.attribute_sub_group = b.attribute_subgroup
ORDER BY a.attribute_name ASC, b.subgroup_id ASC
GO

--------------------------------------------

ALTER TABLE skills
DROP COLUMN fullname, gender, attribute_group, attribute_sub_group, attribute_type
GO

--------------------------------------------

ALTER TABLE skills
ADD user_id int
    CONSTRAINT FK_skills
    FOREIGN KEY (user_id)
REFERENCES users(user_id)
GO


UPDATE skills
SET user_id = userid
GO

ALTER TABLE skills
DROP COLUMN userid
GO

--------------------------------------------

ALTER TABLE skills
ADD name_id int
    CONSTRAINT FK_skill_name
    FOREIGN KEY (name_id)
REFERENCES skill_name(name_id)
ON DELETE CASCADE ON UPDATE CASCADE
GO

UPDATE a
SET
    a.name_id = b.name_id
FROM
    skills AS a
    INNER JOIN skill_name AS b
        ON a.attribute_name = b.attribute_name
GO

ALTER TABLE skills
DROP COLUMN attribute_name
GO
