--//Preppin' Data
//2023: Week 8


--Output

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12),
    CTE2 AS (SELECT *,
                    DATE_FROM_PARTS (2023,"MONTH", 01) "File Date",
                    CASE 
                        WHEN CONTAINS(MARKET_CAP, 'B') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'B', 1) *1000000000 , 0)
                        WHEN CONTAINS(MARKET_CAP, 'M') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'M', 1) *1000000 , 0)
                        END "Market Capitalisation",
                    SPLIT_PART(PURCHASE_PRICE, '$', 2) "Purchase Price",
                    CASE
                    WHEN "Purchase Price" < 25000 THEN 'Low'
                    WHEN "Purchase Price" < 50000 THEN 'Medium'
                    WHEN "Purchase Price" < 75000 THEN 'High'
                    WHEN "Purchase Price" <= 100000 THEN 'Very High'
                    END "Purchase Price Categorisation",
                    CASE
                    WHEN "Market Capitalisation" < 100000000 THEN 'Small'
                    WHEN "Market Capitalisation" < 1000000000 THEN 'Medium'
                    WHEN "Market Capitalisation" < 100000000000 THEN 'Large'
                    WHEN "Market Capitalisation" >= 100000000000 THEN 'Huge'
                    END "Market Capitalisation Categorisation",
                    RANK () OVER (PARTITION BY "File Date", "Purchase Price Categorisation", "Market Capitalisation Categorisation" ORDER BY "Purchase Price" DESC) "Rank"
            FROM CTE
            WHERE "Market Capitalisation" IS NOT NULL)
SELECT "Market Capitalisation Categorisation",
        "Purchase Price Categorisation",
        "File Date",
        TICKER "Ticker", 
        SECTOR "Sector",
        MARKET "Market",
        STOCK_NAME "Stock Name",
        "Market Capitalisation",
        "Purchase Price",
        "Rank"
FROM CTE2
WHERE "Rank" <= 5
;



-- Input each of the 12 monthly files

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12)
SELECT *
FROM CTE
;



--Create a 'file date' using the month found in the file name

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12)
SELECT *,
        DATE_FROM_PARTS (2023,"MONTH", 01) "File Date"
FROM CTE
;



--Clean the Market Cap value to ensure it is the true value as 'Market Capitalisation'
-----Remove any rows with 'n/a'

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12)
SELECT *,
        DATE_FROM_PARTS (2023,"MONTH", 01) "File Date",
        CASE 
            WHEN CONTAINS(MARKET_CAP, 'B') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'B', 1) *1000000000 , 0)
            WHEN CONTAINS(MARKET_CAP, 'M') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'M', 1) *1000000 , 0)
            END "Market Capitalisation"
FROM CTE
WHERE "Market Capitalisation" IS NOT NULL
;



--Categorise the Purchase Price into groupings
-----0 to 24,999.99 as 'Low'
-----25,000 to 49,999.99 as 'Medium'
-----50,000 to 74,999.99 as 'High'
-----75,000 to 100,000 as 'Very High'

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12)
SELECT *,
        DATE_FROM_PARTS (2023,"MONTH", 01) "File Date",
        CASE 
            WHEN CONTAINS(MARKET_CAP, 'B') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'B', 1) *1000000000 , 0)
            WHEN CONTAINS(MARKET_CAP, 'M') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'M', 1) *1000000 , 0)
            END "Market Capitalisation",
        SPLIT_PART(PURCHASE_PRICE, '$', 2) "Purchase Price",
        CASE
        WHEN "Purchase Price" < 25000 THEN 'Low'
        WHEN "Purchase Price" < 50000 THEN 'Medium'
        WHEN "Purchase Price" < 75000 THEN 'High'
        WHEN "Purchase Price" <= 100000 THEN 'Very High'
        END "Purchase Price Category"
FROM CTE
WHERE "Market Capitalisation" IS NOT NULL
;



--Categorise the Market Cap into groupings
-----Below $100M as 'Small'
-----Between $100M and below $1B as 'Medium'
-----Between $1B and below $100B as 'Large' 
-----$100B and above as 'Huge'

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12)
SELECT *,
        DATE_FROM_PARTS (2023,"MONTH", 01) "File Date",
        CASE 
            WHEN CONTAINS(MARKET_CAP, 'B') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'B', 1) *1000000000 , 0)
            WHEN CONTAINS(MARKET_CAP, 'M') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'M', 1) *1000000 , 0)
            END "Market Capitalisation",
        SPLIT_PART(PURCHASE_PRICE, '$', 2) "Purchase Price",
        CASE
        WHEN "Purchase Price" < 25000 THEN 'Low'
        WHEN "Purchase Price" < 50000 THEN 'Medium'
        WHEN "Purchase Price" < 75000 THEN 'High'
        WHEN "Purchase Price" <= 100000 THEN 'Very High'
        END "Purchase Price Category",
        CASE
        WHEN "Market Capitalisation" < 100000000 THEN 'Small'
        WHEN "Market Capitalisation" < 1000000000 THEN 'Medium'
        WHEN "Market Capitalisation" < 100000000000 THEN 'Large'
        WHEN "Market Capitalisation" >= 100000000000 THEN 'Huge'
        END "Market Capitalisation Category"
FROM CTE
WHERE "Market Capitalisation" IS NOT NULL
;



--Rank the highest 5 purchases per combination of: 
----file date, Purchase Price Categorisation and Market Capitalisation Categorisation.

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12)
SELECT *,
        DATE_FROM_PARTS (2023,"MONTH", 01) "File Date",
        CASE 
            WHEN CONTAINS(MARKET_CAP, 'B') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'B', 1) *1000000000 , 0)
            WHEN CONTAINS(MARKET_CAP, 'M') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'M', 1) *1000000 , 0)
            END "Market Capitalisation",
        SPLIT_PART(PURCHASE_PRICE, '$', 2) "Purchase Price",
        CASE
        WHEN "Purchase Price" < 25000 THEN 'Low'
        WHEN "Purchase Price" < 50000 THEN 'Medium'
        WHEN "Purchase Price" < 75000 THEN 'High'
        WHEN "Purchase Price" <= 100000 THEN 'Very High'
        END "Purchase Price Categorisation",
        CASE
        WHEN "Market Capitalisation" < 100000000 THEN 'Small'
        WHEN "Market Capitalisation" < 1000000000 THEN 'Medium'
        WHEN "Market Capitalisation" < 100000000000 THEN 'Large'
        WHEN "Market Capitalisation" >= 100000000000 THEN 'Huge'
        END "Market Capitalisation Categorisation",
        RANK () OVER (PARTITION BY "File Date", "Purchase Price Categorisation", "Market Capitalisation Categorisation" ORDER BY "Purchase Price" DESC) "Rank"
FROM CTE
WHERE "Market Capitalisation" IS NOT NULL
;



--Output only records with a rank of 1 to 5

WITH CTE AS (SELECT *,
                    1 "MONTH"
            FROM PD2023_WK08_01
            UNION ALL
            SELECT *,
                    2 "MONTH"
            FROM PD2023_WK08_02
            UNION ALL
            SELECT *,
                    3 "MONTH"
            FROM PD2023_WK08_03
            UNION ALL
            SELECT *,
                    4 "MONTH"
            FROM PD2023_WK08_04
            UNION ALL
            SELECT *,
                    5 "MONTH"
            FROM PD2023_WK08_05
            UNION ALL
            SELECT *,
                    6 "MONTH"
            FROM PD2023_WK08_06
            UNION ALL
            SELECT *,
                    7 "MONTH"
            FROM PD2023_WK08_07
            UNION ALL
            SELECT *,
                    8 "MONTH"
            FROM PD2023_WK08_08
            UNION ALL
            SELECT *,
                    9 "MONTH"
            FROM PD2023_WK08_09
            UNION ALL
            SELECT *,
                    10 "MONTH"
            FROM PD2023_WK08_10
            UNION ALL
            SELECT *,
                    11 "MONTH"
            FROM PD2023_WK08_11
            UNION ALL
            SELECT *,
                    12 "MONTH"
            FROM PD2023_WK08_12),
    CTE2 AS (SELECT *,
                    DATE_FROM_PARTS (2023,"MONTH", 01) "File Date",
                    CASE 
                        WHEN CONTAINS(MARKET_CAP, 'B') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'B', 1) *1000000000 , 0)
                        WHEN CONTAINS(MARKET_CAP, 'M') THEN ROUND(SPLIT_PART(SPLIT_PART(MARKET_CAP, '$', 2), 'M', 1) *1000000 , 0)
                        END "Market Capitalisation",
                    SPLIT_PART(PURCHASE_PRICE, '$', 2) "Purchase Price",
                    CASE
                    WHEN "Purchase Price" < 25000 THEN 'Low'
                    WHEN "Purchase Price" < 50000 THEN 'Medium'
                    WHEN "Purchase Price" < 75000 THEN 'High'
                    WHEN "Purchase Price" <= 100000 THEN 'Very High'
                    END "Purchase Price Categorisation",
                    CASE
                    WHEN "Market Capitalisation" < 100000000 THEN 'Small'
                    WHEN "Market Capitalisation" < 1000000000 THEN 'Medium'
                    WHEN "Market Capitalisation" < 100000000000 THEN 'Large'
                    WHEN "Market Capitalisation" >= 100000000000 THEN 'Huge'
                    END "Market Capitalisation Categorisation",
                    RANK () OVER (PARTITION BY "File Date", "Purchase Price Categorisation", "Market Capitalisation Categorisation" ORDER BY "Purchase Price" DESC) "Rank"
            FROM CTE
            WHERE "Market Capitalisation" IS NOT NULL)
SELECT "Market Capitalisation Categorisation",
        "Purchase Price Categorisation",
        "File Date",
        TICKER "Ticker", 
        SECTOR "Sector",
        MARKET "Market",
        STOCK_NAME "Stock Name",
        "Market Capitalisation",
        "Purchase Price",
        "Rank"
FROM CTE2
WHERE "Rank" <= 5
;