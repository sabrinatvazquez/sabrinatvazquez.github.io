------Data with Danny
-----Case Study 3
----Foodie-Fi



--B. Data Analysis Questions


--B 1 
---How many customers has Foodie-Fi ever had?

SELECT COUNT(DISTINCT CUSTOMER_ID) CUSTOMERS
FROM SUBSCRIPTIONS
;



--B 2 
---What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT DATE_TRUNC('MONTH', START_DATE) MONTH,
        COUNT(CUSTOMER_ID) DISTRIBUTION
FROM SUBSCRIPTIONS S
JOIN PLANS P
   ON S.PLAN_ID = P.PLAN_ID
WHERE PLAN_NAME LIKE 'trial'
GROUP BY 1
ORDER BY MONTH 
;



--B 3 
---What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

SELECT S.PLAN_ID,
        PLAN_NAME,
        COUNT(START_DATE) EVENTS
FROM SUBSCRIPTIONS S
JOIN PLANS P
   ON S.PLAN_ID = P.PLAN_ID
WHERE YEAR(START_DATE) > 2020
GROUP BY 1,2
ORDER BY S.PLAN_ID
;



--B 4 
---What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

SELECT COUNT(S.CUSTOMER_ID) "CHURNED CUSTOMERS",
        ROUND("CHURNED CUSTOMERS" / (SELECT COUNT(DISTINCT CUSTOMER_ID) CUSTOMERS
                                        FROM SUBSCRIPTIONS) * 100, 1) "% CHURNED CUSTOMERS"
FROM SUBSCRIPTIONS S
JOIN PLANS P
   ON S.PLAN_ID = P.PLAN_ID
WHERE S.PLAN_ID = 4
;



--B 5 
---How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

WITH CTE AS (SELECT CUSTOMER_ID,
                    PLAN_NAME,
                    S.PLAN_ID,
                    START_DATE,
                    LEAD (S.PLAN_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE ASC) "NEXT PLAN"
            FROM SUBSCRIPTIONS S
            JOIN PLANS P
               ON S.PLAN_ID = P.PLAN_ID
            GROUP BY 1,2,3,4
            ORDER BY 1, 5)
SELECT COUNT(CUSTOMER_ID) "CUSTOMERS NEVER PAID",
        ROUND(COUNT(CUSTOMER_ID)/ (SELECT COUNT(DISTINCT CUSTOMER_ID) CUSTOMERS
                         FROM SUBSCRIPTIONS)* 100, 0) "% NEVER PAID"
FROM CTE
WHERE PLAN_ID = 0 
AND "NEXT PLAN" = 4
GROUP BY ALL
;



--B 6 
----What is the number and percentage of customer plans after their initial free trial?

WITH CTE AS (SELECT CUSTOMER_ID,
                    PLAN_NAME,
                    S.PLAN_ID,
                    START_DATE,
                    ROW_NUMBER () OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE ASC) "RN"
            FROM SUBSCRIPTIONS S
            JOIN PLANS P
               ON S.PLAN_ID = P.PLAN_ID
            GROUP BY 1,2,3,4
            ORDER BY 1, 5)
SELECT PLAN_ID,
        PLAN_NAME,
        ROUND(COUNT(CUSTOMER_ID)/ (SELECT COUNT(DISTINCT CUSTOMER_ID) CUSTOMERS
                         FROM SUBSCRIPTIONS)* 100, 1) "% FIRST PLAN"
FROM CTE
WHERE PLAN_ID <> 0
        AND RN = 2
GROUP BY ALL
ORDER BY PLAN_ID
;



--B 7 
---What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH CTE AS (SELECT CUSTOMER_ID,
                    PLAN_NAME,
                    S.PLAN_ID,
                    START_DATE,
                    ROW_NUMBER () OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC) RN
            FROM SUBSCRIPTIONS S
            JOIN PLANS P
               ON S.PLAN_ID = P.PLAN_ID
            WHERE START_DATE < '2021-01-01'
            GROUP BY 1,2,3,4
            ORDER BY 1, 4)
SELECT PLAN_ID,
        PLAN_NAME,
        COUNT(DISTINCT CUSTOMER_ID) CUSTOMERS,
        ROUND(CUSTOMERS/ (SELECT COUNT(DISTINCT CUSTOMER_ID)
                            FROM SUBSCRIPTIONS
                            WHERE START_DATE < '2021-01-01')* 100, 1) "% CUSTOMERS"
FROM CTE
WHERE RN = 1
GROUP BY 1,2
ORDER BY PLAN_ID
;



--B 8 
---How many customers have upgraded to an annual plan in 2020?

SELECT COUNT(CUSTOMER_ID) "UPGRADED TO ANNUAL"
FROM SUBSCRIPTIONS S
WHERE YEAR(START_DATE) = 2020
    AND S.PLAN_ID = 3
;



--B 9 
---How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH CTE AS (SELECT CUSTOMER_ID,
                    PLAN_NAME,
                    S.PLAN_ID,
                    START_DATE
            FROM SUBSCRIPTIONS S
            JOIN PLANS P
             ON S.PLAN_ID = P.PLAN_ID
            WHERE S.PLAN_ID = 0
            ORDER BY 1),
    CTE2 AS (SELECT CUSTOMER_ID,
                    PLAN_NAME,
                    S.PLAN_ID,
                    START_DATE
            FROM SUBSCRIPTIONS S
            JOIN PLANS P
            ON S.PLAN_ID = P.PLAN_ID
            WHERE S.PLAN_ID = 3
            ORDER BY 1)
SELECT ROUND(AVG(CTE2.START_DATE - CTE.START_DATE), 0) "DAYS TO ANNUAL"
FROM CTE
RIGHT JOIN CTE2
ON CTE.CUSTOMER_ID = CTE2.CUSTOMER_ID
;



--B 10 
---Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH CTE AS (SELECT CUSTOMER_ID,
                    START_DATE TRIAL
            FROM SUBSCRIPTIONS S
            WHERE PLAN_ID = 0),
    CTE2 AS (SELECT CUSTOMER_ID,
                    START_DATE ANNUAL
            FROM SUBSCRIPTIONS S
            WHERE PLAN_ID = 3)
SELECT CONCAT(FLOOR(DATEDIFF(DAY, TRIAL, ANNUAL) / 30) * 30,'-',FLOOR(DATEDIFF(DAY, TRIAL, ANNUAL) / 30) * 30 + 30,' DAYS') PERIOD, 
        COUNT(*) CUSTOMER
FROM CTE
JOIN CTE2
ON CTE.CUSTOMER_ID = CTE2.CUSTOMER_ID
WHERE ANNUAL IS NOT NULL
GROUP BY 1
ORDER BY (SPLIT_PART(PERIOD, '-',1))::INT
;



--B 11 
---How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH CTE AS (SELECT CUSTOMER_ID,
                    PLAN_NAME,
                    S.PLAN_ID,
                    START_DATE,
                    LEAD (S.PLAN_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE ASC) "NEXT PLAN"
            FROM SUBSCRIPTIONS S
            JOIN PLANS P
               ON S.PLAN_ID = P.PLAN_ID
            GROUP BY 1,2,3,4
            ORDER BY 1, 5)
SELECT COUNT(CUSTOMER_ID) "CUSTOMERS DOWNGRADED"
FROM CTE
WHERE PLAN_ID = 2
AND "NEXT PLAN" = 1
GROUP BY ALL
;