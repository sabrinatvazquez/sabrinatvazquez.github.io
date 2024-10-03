------Data with Danny
-----Case Study 4
----Data Bank



-----A. Customer Nodes Exploration


--A 1 
---How many unique nodes are there on the Data Bank system?

SELECT COUNT(DISTINCT NODE_ID) "UNIQUE NODES"
FROM CUSTOMER_NODES N
;



--A 2
---What is the number of nodes per region?

SELECT REGION_NAME "REGION",
        COUNT(NODE_ID) "NODES"
FROM CUSTOMER_NODES N
JOIN REGIONS R
    ON N.REGION_ID = R.REGION_ID
GROUP BY 1
ORDER BY 2 DESC
;



--A 3
---How many customers are allocated to each region?

SELECT REGION_NAME "REGION",
        COUNT(DISTINCT CUSTOMER_ID) "CUSTOMERS"
FROM CUSTOMER_NODES N
JOIN REGIONS R
    ON N.REGION_ID = R.REGION_ID
GROUP BY 1
ORDER BY 2 DESC
;



--A 4
---How many days on average are customers reallocated to a different node?

SELECT ROUND(AVG(DATEDIFF('DAY', START_DATE, END_DATE)), 0) "AVERAGEDAYS"
FROM CUSTOMER_NODES N
WHERE END_DATE <> '9999-12-31'
;



--A 5
---What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

WITH CTE AS (SELECT R.REGION_NAME,
                    N.CUSTOMER_ID,
                    ROUND(DATEDIFF(DAY, START_DATE, END_DATE), 0) DAYS
            FROM CUSTOMER_NODES N
            JOIN REGIONS R
                ON N.REGION_ID = R.REGION_ID
            WHERE END_DATE <> '9999-12-31')
SELECT DISTINCT REGION_NAME,
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY DAYS) OVER(PARTITION BY REGION_NAME), 0) MEDIAN, 
        ROUND(PERCENTILE_CONT(0.80) WITHIN GROUP(ORDER BY DAYS) OVER(PARTITION BY REGION_NAME), 0) "PERCENTILE 80",
        ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY DAYS) OVER(PARTITION BY REGION_NAME), 0) "PERCENTILE 95"
FROM CTE
ORDER BY 1
;