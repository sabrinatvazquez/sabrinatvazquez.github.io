------Data with Danny
-----Case Study 2
----Pizza Runner



-----A. Pizza Metrics


--A 1 
---How many pizzas were ordered?

SELECT COUNT(PIZZA_ID) "TOTAL PIZZAS ORDERED"
FROM CUSTOMER_ORDERS
;



--A 2 
---How many unique customer orders were made?

SELECT COUNT(DISTINCT ORDER_ID) "NUMBER OF UNIQUE ORDERS"
FROM CUSTOMER_ORDERS
;



--A 3 
---How many successful orders were delivered by each runner?

SELECT RUNNER_ID,
        COUNT(PICKUP_TIME) AS "TOTAL SUCCESSFUL ORDERS"
FROM RUNNER_ORDERS
WHERE PICKUP_TIME <> 'null'
GROUP BY RUNNER_ID
;



--A 4 
---How many of each type of pizza was delivered?

SELECT P.PIZZA_NAME,
        COUNT (C.PIZZA_ID) AS "NUMBER OF PIZZAS"
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R
    ON C.ORDER_ID = R.ORDER_ID
JOIN PIZZA_NAMES AS P
    ON C.PIZZA_ID = P.PIZZA_ID
WHERE PICKUP_TIME <> 'null'
GROUP BY P.PIZZA_NAME
;



--A 5 
---How many Vegetarian and Meatlovers were ordered by each customer?

SELECT C.CUSTOMER_ID,
        P.PIZZA_NAME,
        COUNT (C.PIZZA_ID) AS "NUMBER OF PIZZAS"
FROM CUSTOMER_ORDERS AS C
JOIN PIZZA_NAMES AS P
    ON C.PIZZA_ID = P.PIZZA_ID
GROUP BY C.CUSTOMER_ID, 
        P.PIZZA_NAME
ORDER BY CUSTOMER_ID, PIZZA_NAME
;



--A 6 
---What was the maximum number of pizzas delivered in a single order?

SELECT COUNT (C.PIZZA_ID) AS "MAX NUMBER OF PIZZAS DELIVERED"
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R
    ON C.ORDER_ID = R.ORDER_ID
WHERE R.PICKUP_TIME <> 'null'
GROUP BY C.ORDER_ID
ORDER BY "MAX NUMBER OF PIZZAS DELIVERED" DESC
LIMIT 1
;



--A 7 
---For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

WITH CTE AS (SELECT C.ORDER_ID,
                    CUSTOMER_ID,
                    PIZZA_ID,
                    EXCLUSIONS LIKE 'null'
                            OR EXCLUSIONS LIKE '' "EXCLUSIONS?",
                    EXTRAS IS NULL
                            OR EXTRAS LIKE 'null'
                            OR EXTRAS LIKE '' "EXTRAS?"
            FROM CUSTOMER_ORDERS C
            JOIN RUNNER_ORDERS R
                ON C.ORDER_ID = R.ORDER_ID
            WHERE R.PICKUP_TIME <> 'null')
SELECT CUSTOMER_ID,
        COUNT(CASE 
                WHEN "EXCLUSIONS?" = FALSE 
                    OR "EXTRAS?" = FALSE
                    THEN 'CHANGES'
                END) CHANGES,
        COUNT(CASE 
                WHEN "EXCLUSIONS?" = TRUE
                    AND "EXTRAS?" = TRUE
                    THEN 'NO CHANGES'
                END) "NO CHANGES"
FROM CTE
GROUP BY 1
;



-- A 8 
---How many pizzas were delivered that had both exclusions and extras?

WITH CTE AS (SELECT C.ORDER_ID,
                    CUSTOMER_ID,
                    PIZZA_ID,
                    CASE EXCLUSIONS LIKE 'null'
                            OR EXCLUSIONS LIKE ''
                    WHEN TRUE THEN 0
                    WHEN FALSE THEN 1
                    END "EXCLUSIONS?",
                    CASE EXTRAS IS NULL
                            OR EXTRAS LIKE 'null'
                            OR EXTRAS LIKE ''
                    WHEN TRUE THEN 0
                    WHEN FALSE THEN 1
                    END "EXTRAS?"
            FROM CUSTOMER_ORDERS C
            JOIN RUNNER_ORDERS R
                ON C.ORDER_ID = R.ORDER_ID
            WHERE R.PICKUP_TIME <> 'null')
SELECT COUNT(PIZZA_ID) "PIZZAS WITH BOTH CHANGES"
FROM CTE
WHERE "EXCLUSIONS?" + "EXTRAS?" = 2
;



--A 9 
---What was the total volume of pizzas ordered for each hour of the day?

SELECT HOUR(ORDER_TIME) "HOUR OF DAY",
        COUNT(PIZZA_ID) "NUMBER OF PIZZAS"
FROM CUSTOMER_ORDERS C
GROUP BY 1
ORDER BY 1
;



--A 10 
---What was the volume of orders for each day of the week?

SELECT DAYNAME(ORDER_TIME) "DAY OF WEEK",
        COUNT(PIZZA_ID) "NUMBER OF PIZZAS"
FROM CUSTOMER_ORDERS C
GROUP BY 1
ORDER BY 2 DESC
;
