------Data with Danny
-----Case Study 4
----Data Bank



-----B.Customer Transactions


--B 1 
---What is the unique count and total amount for each transaction type?

SELECT TXN_TYPE,
        COUNT(*) "UNIQUE COUNT",
        SUM(TXN_AMOUNT) "TOTAL AMOUNT"
FROM CUSTOMER_TRANSACTIONS T
GROUP BY 1
ORDER BY 1
;



--B 2
---What is the average total historical deposit counts and amounts for all customers?

WITH CTE AS (SELECT  CUSTOMER_ID,
                    COUNT(*) COUNT,
                    SUM(TXN_AMOUNT) "TOTAL AMOUNT"
            FROM CUSTOMER_TRANSACTIONS T
            WHERE TXN_TYPE = 'deposit'
            GROUP BY 1)
SELECT ROUND(AVG(COUNT), 0),
        ROUND(AVG("TOTAL AMOUNT"), 0)
FROM CTE
;



--B 3
---For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

WITH CTE AS (SELECT CUSTOMER_ID,
                    MONTHNAME(TXN_DATE) MONTH,
                    MONTH(TXN_DATE) NMONTH,
                    COUNT(CASE TXN_TYPE 
                        WHEN 'deposit' THEN 1
                        END) DEPOSITS,
                    COUNT(CASE TXN_TYPE 
                        WHEN 'purchase' THEN 1
                        END) PURCHASES,
                    COUNT(CASE TXN_TYPE 
                        WHEN 'withdrawal' THEN 1
                        END) WITHDRAWALS
            FROM CUSTOMER_TRANSACTIONS T
            GROUP BY 1, 2, 3 
            ORDER BY 1, 3)
SELECT MONTH,
        COUNT(DISTINCT CUSTOMER_ID) "NUMBER OF CUSTOMERS"
FROM CTE
WHERE DEPOSITS > 1
    AND (PURCHASES >= 1
        OR WITHDRAWALS >= 1)
GROUP BY 1, NMONTH
ORDER BY NMONTH
;



--B 4
---What is the closing balance for each customer at the end of the month?

WITH CTE AS (SELECT CUSTOMER_ID,
                    DATE_TRUNC('MONTH', TXN_DATE) MONTH,
                    SUM(CASE TXN_TYPE
                        WHEN 'deposit' THEN TXN_AMOUNT
                        ELSE -1 * TXN_AMOUNT
                        END) ADJAMOUNT
            FROM CUSTOMER_TRANSACTIONS T
            GROUP BY 1, 2
            ORDER BY 1, 3)
SELECT CUSTOMER_ID, 
        MONTHNAME(MONTH),
        SUM(ADJAMOUNT) OVER (PARTITION BY CUSTOMER_ID ORDER BY MONTH) BALANCE
FROM CTE
GROUP BY 1, MONTH, MONTH(MONTH), ADJAMOUNT
ORDER BY 1, MONTH(MONTH)
;



--B 5
---What is the percentage of customers who increase their closing balance by more than 5%?

WITH CTE AS (SELECT CUSTOMER_ID,
                    DATEADD('DAY', -1, DATEADD( 'MONTH', 1, DATE_TRUNC('MONTH', TXN_DATE))) MONTHEND,
                    SUM(CASE TXN_TYPE
                        WHEN 'deposit' THEN TXN_AMOUNT
                        ELSE -1 * TXN_AMOUNT
                        END) ADJAMOUNT
            FROM CUSTOMER_TRANSACTIONS T
            GROUP BY 1, 2
            ORDER BY 1, 3),
 CTE2 AS (SELECT CUSTOMER_ID, 
                MONTHEND,
                SUM(ADJAMOUNT) OVER (PARTITION BY CUSTOMER_ID ORDER BY MONTHEND) BALANCE
        FROM CTE
        GROUP BY 1, MONTHEND, ADJAMOUNT
        ORDER BY 1, MONTHEND),
CTE3 AS (SELECT CUSTOMER_ID, 
                MONTHEND,
                BALANCE,
                LAG(BALANCE) OVER (PARTITION BY CUSTOMER_ID ORDER BY MONTHEND) PREV_BALANCE,
                ((BALANCE - PREV_BALANCE) / ABS(NULLIF((PREV_BALANCE),0)))  * 100 "% DIFF"
        FROM CTE2
        ORDER BY 1, MONTHEND)
SELECT (COUNT(DISTINCT CUSTOMER_ID) / (SELECT COUNT(DISTINCT CUSTOMER_ID)
                                        FROM CUSTOMER_TRANSACTIONS))  *100.0 :: FLOAT PERCENT
FROM CTE3     
WHERE "% DIFF" > 5.0
;