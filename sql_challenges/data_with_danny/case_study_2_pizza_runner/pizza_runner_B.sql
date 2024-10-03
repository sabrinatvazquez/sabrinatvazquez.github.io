------Data with Danny
-----Case Study 2
----Pizza Runner



-----B. Runner and Customer Experience


--B 1 
---How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT WEEK(REGISTRATION_DATE) WEEK,
        COUNT(DISTINCT RUNNER_ID) RUNNER
FROM RUNNERS
GROUP BY 1
ORDER BY 1
;



--B 2 
---What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT RUNNER_ID,
    ROUND(AVG(TIMEDIFF ('MINUTE', ORDER_TIME, TRY_TO_TIMESTAMP(PICKUP_TIME))), 2) "AVERAGE MINUTES"
FROM CUSTOMER_ORDERS C
JOIN RUNNER_ORDERS RO
    ON C.ORDER_ID = RO.ORDER_ID
GROUP BY 1
;



--B 3 
---Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT COUNT(PIZZA_ID) "NUMBER OF PIZZAS",
        TIMEDIFF ('MINUTE', ORDER_TIME, TRY_TO_TIMESTAMP(PICKUP_TIME)) "PREP TIME"
FROM CUSTOMER_ORDERS C
JOIN RUNNER_ORDERS RO
    ON C.ORDER_ID = RO.ORDER_ID
WHERE PICKUP_TIME <> 'null'
GROUP BY ORDER_TIME, PICKUP_TIME
ORDER BY 1, "PREP TIME"
;



--B 4 
---What was the average distance travelled for each customer?

SELECT CUSTOMER_ID,
        ROUND(AVG(REGEXP_SUBSTR (DISTANCE, '(\\d+.*\\d+)')),2) "DISTANCE KM"
FROM CUSTOMER_ORDERS C
JOIN RUNNER_ORDERS RO
    ON C.ORDER_ID = RO.ORDER_ID
GROUP BY 1
;



--B 5 
---What was the difference between the longest and shortest delivery times for all orders?

WITH CTE AS (SELECT REGEXP_SUBSTR (DURATION, '(\\d+)') "DELIVERY TIME"
            FROM RUNNER_ORDERS RO)
SELECT MAX("DELIVERY TIME") - MIN("DELIVERY TIME") "DELIVERY TIME RANGE"
FROM CTE 
;



--B 6 
---What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT RUNNER_ID,
        ORDER_ID,
        ROUND(AVG(REGEXP_SUBSTR (DISTANCE, '(\\d+.*\\d+)') / REGEXP_SUBSTR (DURATION, '(\\d+)') * 60), 2) "AVG SPEED"
FROM RUNNER_ORDERS RO
WHERE DURATION <> 'null'
GROUP BY 1, 2
ORDER BY 1, 2
;



--B 7 
---What is the successful delivery percentage for each runner?

WITH CTE AS (SELECT RUNNER_ID,
                    COUNT(ORDER_ID) "SUCCESSFUL"
            FROM RUNNER_ORDERS RO
            WHERE PICKUP_TIME <> 'null'
            GROUP BY 1)
SELECT CTE.RUNNER_ID, 
        ROUND("SUCCESSFUL" / COUNT(RO.ORDER_ID) * 100, 0) "% SUCCESSFUL"
FROM CTE 
JOIN RUNNER_ORDERS RO
    ON CTE.RUNNER_ID = RO.RUNNER_ID
GROUP BY 1, "SUCCESSFUL"
;