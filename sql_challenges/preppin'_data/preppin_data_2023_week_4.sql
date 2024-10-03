//Preppin' Data
//2023: Week 4


--Output

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK04_JANUARY
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK04_FEBRUARY
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK04_MARCH
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK04_APRIL
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK04_MAY
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK04_JUNE
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK04_JULY
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK04_AUGUST
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK04_SEPTEMBER
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK04_OCTOBER
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK04_NOVEMBER
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK04_DECEMBER),
   CTE2 AS (SELECT *,
            DATE_FROM_PARTS (2023,"MONTH",JOINING_DAY) "Joining Date"
            FROM CTE)
SELECT ID,
        MIN("Joining Date") AS "Joining Date",
        ACCOUNT_TYPE,
        DATE_OF_BIRTH :: DATE AS "Date of Birth",
        ETHNICITY
FROM CTE2
PIVOT(MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity','Account Type','Date of Birth')) AS P
    (ID,
    JOINING_DAY,
    MONTH,
    "Joining Date",
    ETHNICITY,
    ACCOUNT_TYPE,
    DATE_OF_BIRTH)
GROUP BY ALL
;



--We want to stack the tables on top of one another, since they have the same fields in each sheet.

SELECT *,
        1 MONTH
FROM PD2023_WK04_JANUARY
UNION ALL
SELECT *,
        2 MONTH
FROM PD2023_WK04_FEBRUARY
UNION ALL
SELECT *,
        3 MONTH
FROM PD2023_WK04_MARCH
UNION ALL
SELECT *,
        4 MONTH
FROM PD2023_WK04_APRIL
UNION ALL
SELECT *,
        5 MONTH
FROM PD2023_WK04_MAY
UNION ALL
SELECT *,
        6 MONTH
FROM PD2023_WK04_JUNE
UNION ALL
SELECT *,
        7 MONTH
FROM PD2023_WK04_JULY
UNION ALL
SELECT *,
        8 MONTH
FROM PD2023_WK04_AUGUST
UNION ALL
SELECT *,
        9 MONTH
FROM PD2023_WK04_SEPTEMBER
UNION ALL
SELECT *,
        10 MONTH
FROM PD2023_WK04_OCTOBER
UNION ALL
SELECT *,
        11 MONTH
FROM PD2023_WK04_NOVEMBER
UNION ALL
SELECT *,
        12 MONTH
FROM PD2023_WK04_DECEMBER
;



--Make a Joining Date field based on the Joining Day, Table Names and the year 2023

WITH CTE AS (SELECT *,
                    1 MONTH
            FROM PD2023_WK04_JANUARY
            UNION ALL
            SELECT *,
                    2 MONTH
            FROM PD2023_WK04_FEBRUARY
            UNION ALL
            SELECT *,
                    3 MONTH
            FROM PD2023_WK04_MARCH
            UNION ALL
            SELECT *,
                    4 MONTH
            FROM PD2023_WK04_APRIL
            UNION ALL
            SELECT *,
                    5 MONTH
            FROM PD2023_WK04_MAY
            UNION ALL
            SELECT *,
                    6 MONTH
            FROM PD2023_WK04_JUNE
            UNION ALL
            SELECT *,
                    7 MONTH
            FROM PD2023_WK04_JULY
            UNION ALL
            SELECT *,
                    8 MONTH
            FROM PD2023_WK04_AUGUST
            UNION ALL
            SELECT *,
                    9 MONTH
            FROM PD2023_WK04_SEPTEMBER
            UNION ALL
            SELECT *,
                    10 MONTH
            FROM PD2023_WK04_OCTOBER
            UNION ALL
            SELECT *,
                    11 MONTH
            FROM PD2023_WK04_NOVEMBER
            UNION ALL
            SELECT *,
                    12 MONTH
            FROM PD2023_WK04_DECEMBER)
SELECT  *,
        DATE_FROM_PARTS (2023,MONTH,JOINING_DAY) "Joining Date"
FROM CTE
;



--Now we want to reshape our data so we have a field for each demographic, for each new customer

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK04_JANUARY
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK04_FEBRUARY
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK04_MARCH
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK04_APRIL
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK04_MAY
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK04_JUNE
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK04_JULY
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK04_AUGUST
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK04_SEPTEMBER
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK04_OCTOBER
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK04_NOVEMBER
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK04_DECEMBER),
   CTE2 AS (SELECT *,
            DATE_FROM_PARTS (2023,"MONTH",JOINING_DAY) "Joining Date"
            FROM CTE)
SELECT *
FROM CTE2
PIVOT(MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity','Account Type','Date of Birth')) AS P
    (ID,
    JOINING_DAY,
    MONTH,
    "Joining Date",
    ETHNICITY,
    ACCOUNT_TYPE,
    DATE_OF_BIRTH)
;



--Make sure all the data types are correct for each field

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK04_JANUARY
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK04_FEBRUARY
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK04_MARCH
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK04_APRIL
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK04_MAY
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK04_JUNE
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK04_JULY
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK04_AUGUST
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK04_SEPTEMBER
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK04_OCTOBER
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK04_NOVEMBER
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK04_DECEMBER),
   CTE2 AS (SELECT *,
            DATE_FROM_PARTS (2023,"MONTH",JOINING_DAY) "Joining Date"
            FROM CTE)
SELECT *,
        DATE_OF_BIRTH :: DATE AS "Date of Birth"
FROM CTE2
PIVOT(MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity','Account Type','Date of Birth')) AS P
    (ID,
    JOINING_DAY,
    MONTH,
    "Joining Date",
    ETHNICITY,
    ACCOUNT_TYPE,
    DATE_OF_BIRTH)
;



--Remove duplicates. If a customer appears multiple times take their earliest joining date

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK04_JANUARY
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK04_FEBRUARY
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK04_MARCH
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK04_APRIL
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK04_MAY
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK04_JUNE
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK04_JULY
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK04_AUGUST
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK04_SEPTEMBER
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK04_OCTOBER
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK04_NOVEMBER
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK04_DECEMBER),
   CTE2 AS (SELECT *,
            DATE_FROM_PARTS (2023,"MONTH",JOINING_DAY) "Joining Date"
            FROM CTE)
SELECT ID,
        MIN("Joining Date") AS "Joining Date",
        ACCOUNT_TYPE,
        DATE_OF_BIRTH :: DATE AS "Date of Birth",
        ETHNICITY
FROM CTE2
PIVOT(MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity','Account Type','Date of Birth')) AS P
    (ID,
    JOINING_DAY,
    MONTH,
    "Joining Date",
    ETHNICITY,
    ACCOUNT_TYPE,
    DATE_OF_BIRTH)
GROUP BY ALL
;