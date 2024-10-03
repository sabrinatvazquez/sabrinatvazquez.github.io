//Preppin' Data
//2023: Week 5


--Output

WITH CTE AS (SELECT MONTHNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date",
                    SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
                    SUM(VALUE) "Value",
                    RANK() OVER (PARTITION BY "Transaction Date" ORDER BY "Value" DESC) AS "Bank Rank per Month"
            FROM PD2023_WK01 
            GROUP BY ALL
            ORDER BY 1, 3 DESC, 2)
SELECT "Transaction Date",
        "Bank",
        "Value",
        "Bank Rank per Month",
        AVG("Value") OVER (PARTITION BY "Bank Rank per Month") "Avg Transaction Value per Rank",
        AVG("Bank Rank per Month") OVER (PARTITION BY "Bank") "Avg Rank per Bank"
FROM CTE
GROUP BY 1, 2, 3, 4
ORDER BY "Transaction Date", "Value" DESC, "Bank"
;



--Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'

SELECT *,
    SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank"
FROM PD2023_WK01
;



--Change transaction date to the just be the month of the transaction

SELECT *,
        SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        CASE WHEN ONLINE_OR_IN_PERSON = 1 
            THEN 'Online'
            ELSE 'In-Person'
            END "Online or In-Person",
        MONTHNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date"
FROM PD2023_WK01
;



--Total up the transaction values so you have one row for each bank and month combination

SELECT SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        MONTHNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date",
        SUM(VALUE) "Value"
FROM PD2023_WK01 
GROUP BY ALL
ORDER BY  "Bank"
;



--Rank each bank for their value of transactions each month against the other banks. 1st is the highest value of transactions, 3rd the lowest. 


SELECT MONTHNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date",
        SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        SUM(VALUE) "Value",
        RANK() OVER (PARTITION BY "Transaction Date" ORDER BY "Value" DESC) AS "Bank Rank per Month"
FROM PD2023_WK01 
GROUP BY ALL
ORDER BY "Transaction Date", "Value" DESC, "Bank"
;



--Without losing all of the other data fields, find: 
--The average rank a bank has across all of the months, call this field 'Avg Rank per Bank' 
--The average transaction value per rank, call this field 'Avg Transaction Value per Rank'


WITH CTE AS (SELECT MONTHNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date",
                    SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
                    SUM(VALUE) "Value",
                    RANK() OVER (PARTITION BY "Transaction Date" ORDER BY "Value" DESC) AS "Bank Rank per Month"
            FROM PD2023_WK01 
            GROUP BY ALL
            ORDER BY 1, 3 DESC, 2)
SELECT "Transaction Date",
        "Bank",
        "Value",
        "Bank Rank per Month",
        AVG("Bank Rank per Month") OVER (PARTITION BY "Bank") "Avg Rank per Bank",
        AVG("Value") OVER (PARTITION BY "Bank Rank per Month") "Avg Transaction Value per Rank"
FROM CTE
GROUP BY 1, 2, 3, 4
;