------Data with Danny
-----Case Study 2
----Pizza Runner



-----D. Pricing and Ratings


--D 1 
---If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

WITH CTE AS (SELECT ROW_NUMBER() OVER (ORDER BY C.ORDER_ID, C.PIZZA_ID) RN,
                    C.ORDER_ID,
                    C.PIZZA_ID,
                    CASE C.PIZZA_ID
                        WHEN 1 THEN 12
                        WHEN 2 THEN 10
                        END PRICE
            FROM CUSTOMER_ORDERS C
            JOIN RUNNER_ORDERS R
                ON C.ORDER_ID = R.ORDER_ID
            WHERE R.PICKUP_TIME <> 'null')
SELECT SUM(PRICE) "MONEY MADE"
FROM CTE
;



--D 2 
---What if there was an additional $1 charge for any pizza extras?
----Add cheese is $1 extra

WITH CTE AS (SELECT ROW_NUMBER() OVER (ORDER BY C.ORDER_ID, C.PIZZA_ID) RN,
                    C.ORDER_ID,
                    C.PIZZA_ID,
                    CASE 
                            WHEN EXTRAS IS NULL
                                        OR EXTRAS LIKE 'null'
                                        OR EXTRAS LIKE '' THEN '' 
                                        ELSE EXTRAS
                                        END
                                        -- , ', ', '') 
                                        EXTRA,
                    SPLIT_PART(EXTRA, ', ', 1) EXTRA1,
                    SPLIT_PART(EXTRA, ', ', 2) EXTRA2,
                    CASE 
                        WHEN EXTRA2 <> '' THEN 2
                        WHEN EXTRA1 <> '' THEN 1
                        ELSE 0
                        END "#EXTRAS",
                    CASE C.PIZZA_ID
                        WHEN 1 THEN 12
                        WHEN 2 THEN 10
                        END PRICE,
                    "#EXTRAS" + PRICE "TOTAL PRICE"
            FROM CUSTOMER_ORDERS C
            JOIN RUNNER_ORDERS R
                ON C.ORDER_ID = R.ORDER_ID
            WHERE R.PICKUP_TIME <> 'null')
SELECT SUM("TOTAL PRICE") "MONEY MADE"
FROM CTE
;



-- D 5
---If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

WITH ORDERS AS (SELECT ROW_NUMBER() OVER (ORDER BY C.ORDER_ID, C.PIZZA_ID) RN,
                        C.ORDER_ID,
                        C.PIZZA_ID,
                        CASE C.PIZZA_ID
                        WHEN 1 THEN 12
                        WHEN 2 THEN 10
                        END PRICE,
                FROM CUSTOMER_ORDERS C
                JOIN RUNNER_ORDERS R
                    ON C.ORDER_ID = R.ORDER_ID
                WHERE R.PICKUP_TIME <> 'null'),
     RUNNERS AS (SELECT ORDERS.ORDER_ID,
                        ROUND(AVG(REGEXP_SUBSTR (DISTANCE, '(\\d+.*\\d+)')),2) DISTANCEKM,
                        DISTANCEKM * 0.30 RUNNERSWAGES
                FROM ORDERS
                JOIN RUNNER_ORDERS R
                     ON ORDERS.ORDER_ID = R.ORDER_ID
                WHERE R.PICKUP_TIME <> 'null'
                GROUP BY ALL),
    PRICE AS (SELECT SUM(PRICE) SUMPRICE
                FROM ORDERS)
SELECT SUMPRICE - SUM(RUNNERSWAGES) "TOTAL AMOUNT"
FROM PRICE
JOIN RUNNERS
GROUP BY SUMPRICE
;