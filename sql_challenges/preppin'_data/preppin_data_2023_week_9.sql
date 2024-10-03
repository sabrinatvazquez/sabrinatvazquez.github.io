//Preppin' Data
//2023: Week 9

--Output

WITH CTE AS (SELECT ACCOUNT_TO "Account ID",
                    TRANSACTION_DATE "Transaction Date",
                    VALUE "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_TRANSACTION_PATH P
            JOIN PD2023_WK07_TRANSACTION_DETAIL D
                ON P.TRANSACTION_ID = D.TRANSACTION_ID
            JOIN PD2023_WK07_ACCOUNT_INFORMATION A
                ON P.ACCOUNT_TO = A.ACCOUNT_NUMBER
            WHERE CANCELLED_ <> 'Y'
            AND BALANCE_DATE= '2023-01-31'
            
            UNION ALL 
            
            SELECT ACCOUNT_FROM "Account ID",
                    TRANSACTION_DATE "Transaction Date",
                    (VALUE * -1) "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_TRANSACTION_PATH P
            JOIN PD2023_WK07_TRANSACTION_DETAIL D
                ON P.TRANSACTION_ID = D.TRANSACTION_ID
            JOIN PD2023_WK07_ACCOUNT_INFORMATION A
                ON P.ACCOUNT_FROM = A.ACCOUNT_NUMBER
            WHERE CANCELLED_ <> 'Y'
            AND BALANCE_DATE = '2023-01-31'
            
            UNION ALL
            
            SELECT ACCOUNT_NUMBER "Account ID",
                    BALANCE_DATE "Transaction Date",
                    NULL "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_ACCOUNT_INFORMATION A
            )
SELECT "Account ID" "Account Number",
        "Transaction Date" "Balance Date",
        "Value" "Transaction Value",
        SUM(ZEROIFNULL("Value")) OVER (PARTITION BY "Account ID" ORDER BY "Transaction Date" ASC, "Value" DESC) + "Balance" "Balance"
FROM CTE
ORDER BY 1, 2, 3 DESC
;



--For Transactuon Path
--Make sure field naming convention matches the other tables

SELECT P.TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account To",
        ACCOUNT_FROM "Account From"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
;


    
--Filter out the cancelled transactions

SELECT P.TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account To",
        ACCOUNT_FROM "Account From"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
WHERE CANCELLED_ <> 'Y'
;



--Split the flow into incoming and outgoing transactions 

SELECT P.TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account ID",
        TRANSACTION_DATE "Transaction Date"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
WHERE CANCELLED_ <> 'Y'
;

SELECT P.TRANSACTION_ID "Transaction ID",
        ACCOUNT_FROM "Account ID",
        TRANSACTION_DATE "Transaction Date"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
WHERE CANCELLED_ <> 'Y'
;



--Bring the data together with the Balance as of 31st Jan 

SELECT P.TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account ID",
        TRANSACTION_DATE "Transaction Date"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
JOIN PD2023_WK07_ACCOUNT_INFORMATION A
    ON P.ACCOUNT_TO = A.ACCOUNT_NUMBER
WHERE CANCELLED_ <> 'Y'
AND BALANCE_DATE= '2023-01-31'

UNION ALL 

SELECT P.TRANSACTION_ID "Transaction ID",
        ACCOUNT_FROM "Account ID",
        TRANSACTION_DATE "Transaction Date"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
JOIN PD2023_WK07_ACCOUNT_INFORMATION A
    ON P.ACCOUNT_FROM = A.ACCOUNT_NUMBER
WHERE CANCELLED_ <> 'Y'
AND BALANCE_DATE= '2023-01-31'
;



--Work out the order that transactions occur for each account
----Where multiple transactions happen on the same day, assume the highest value transactions happen first

SELECT ACCOUNT_TO "Account ID",
        TRANSACTION_DATE "Transaction Date",
        VALUE "Value"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
JOIN PD2023_WK07_ACCOUNT_INFORMATION A
    ON P.ACCOUNT_TO = A.ACCOUNT_NUMBER
WHERE CANCELLED_ <> 'Y'
AND BALANCE_DATE= '2023-01-31'

UNION ALL 

SELECT ACCOUNT_FROM "Account ID",
        TRANSACTION_DATE "Transaction Date",
        VALUE "Value"
FROM PD2023_WK07_TRANSACTION_PATH P
JOIN PD2023_WK07_TRANSACTION_DETAIL D
    ON P.TRANSACTION_ID = D.TRANSACTION_ID
JOIN PD2023_WK07_ACCOUNT_INFORMATION A
    ON P.ACCOUNT_FROM = A.ACCOUNT_NUMBER
WHERE CANCELLED_ <> 'Y'
AND BALANCE_DATE = '2023-01-31'
ORDER BY 1, 2, 3 DESC
;



--Use a running sum to calculate the Balance for each account on each day

WITH CTE AS (SELECT ACCOUNT_TO "Account ID",
                    TRANSACTION_DATE "Transaction Date",
                    VALUE "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_TRANSACTION_PATH P
            JOIN PD2023_WK07_TRANSACTION_DETAIL D
                ON P.TRANSACTION_ID = D.TRANSACTION_ID
            JOIN PD2023_WK07_ACCOUNT_INFORMATION A
                ON P.ACCOUNT_TO = A.ACCOUNT_NUMBER
            WHERE CANCELLED_ <> 'Y'
            AND BALANCE_DATE= '2023-01-31'
            
            UNION ALL 
            
            SELECT ACCOUNT_FROM "Account ID",
                    TRANSACTION_DATE "Transaction Date",
                    (VALUE * -1) "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_TRANSACTION_PATH P
            JOIN PD2023_WK07_TRANSACTION_DETAIL D
                ON P.TRANSACTION_ID = D.TRANSACTION_ID
            JOIN PD2023_WK07_ACCOUNT_INFORMATION A
                ON P.ACCOUNT_FROM = A.ACCOUNT_NUMBER
            WHERE CANCELLED_ <> 'Y'
            AND BALANCE_DATE = '2023-01-31')
SELECT "Account ID" "Account Number",
        "Transaction Date" "Balance Date",
        "Value" "Transaction Value",
        SUM("Value") OVER (PARTITION BY "Account ID" ORDER BY "Transaction Date" ASC, "Value" DESC) + "Balance" "Balance"
FROM CTE
ORDER BY 1, 2, 3 DESC
;



--The Transaction Value should be null for 31st Jan, as this is the starting balance

WITH CTE AS (SELECT ACCOUNT_TO "Account ID",
                    TRANSACTION_DATE "Transaction Date",
                    VALUE "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_TRANSACTION_PATH P
            JOIN PD2023_WK07_TRANSACTION_DETAIL D
                ON P.TRANSACTION_ID = D.TRANSACTION_ID
            JOIN PD2023_WK07_ACCOUNT_INFORMATION A
                ON P.ACCOUNT_TO = A.ACCOUNT_NUMBER
            WHERE CANCELLED_ <> 'Y'
            AND BALANCE_DATE= '2023-01-31'
            
            UNION ALL 
            
            SELECT ACCOUNT_FROM "Account ID",
                    TRANSACTION_DATE "Transaction Date",
                    (VALUE * -1) "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_TRANSACTION_PATH P
            JOIN PD2023_WK07_TRANSACTION_DETAIL D
                ON P.TRANSACTION_ID = D.TRANSACTION_ID
            JOIN PD2023_WK07_ACCOUNT_INFORMATION A
                ON P.ACCOUNT_FROM = A.ACCOUNT_NUMBER
            WHERE CANCELLED_ <> 'Y'
            AND BALANCE_DATE = '2023-01-31'
            
            UNION ALL
            
            SELECT ACCOUNT_NUMBER "Account ID",
                    BALANCE_DATE "Transaction Date",
                    NULL "Value",
                    BALANCE "Balance"
            FROM PD2023_WK07_ACCOUNT_INFORMATION A
            )
SELECT "Account ID" "Account Number",
        "Transaction Date" "Balance Date",
        "Value" "Transaction Value",
        SUM("Value") OVER (PARTITION BY "Account ID" ORDER BY "Transaction Date" ASC, "Value" DESC) + "Balance" "Balance"
FROM CTE
ORDER BY 1, 2, 3 DESC
;