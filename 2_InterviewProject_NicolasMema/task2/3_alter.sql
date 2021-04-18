ALTER TABLE hours
ADD 
    hours_per_month float(2),
    utilization float(2),
    client_time float(2),
    admin_time float(2)
GO

ALTER TABLE skills
ADD
    level_description varchar(100)
GO

UPDATE hours
SET
    hours_per_month = 160.00
GO

UPDATE hours
SET
    utilization = CASE
        WHEN (adminhrs1 + adminhrs2 + adminhrs3) = hours_per_month THEN 0
        ELSE ((clienthrs1 + clienthrs2 + clienthrs3) / (hours_per_month - (adminhrs1 + adminhrs2 + adminhrs3)))
        END,
    client_time = ((clienthrs1 + clienthrs2 + clienthrs3) / (hours_per_month)),
    admin_time = (adminhrs1 + adminhrs2 + adminhrs3) / hours_per_month
GO

UPDATE skills
SET level_description = CASE
    WHEN attribute_level = 0 THEN 'wants to learn'
    WHEN attribute_level IN (1, 2) THEN 'Heavy supervision'
    WHEN attribute_level IN (3, 4) THEN 'Light supervision'
    ELSE 'Expert'
END
GO