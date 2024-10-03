//Preppin' Data
//2023: Week 1


--Output 1: Total Values of Transactions by each bank

SELECT SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        SUM(VALUE) "Value"
FROM PD2023_WK01
GROUP BY 1
; 



--Output 2: Total Values by Bank, Day of the Week and Type of Transaction

SELECT SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        CASE WHEN ONLINE_OR_IN_PERSON = 1 
            THEN 'Online'
            ELSE 'In-Person'
            END "Online or In-Person",
        DAYNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date",
        SUM(VALUE) "Value"
FROM PD2023_WK01 
GROUP BY ALL
;



--Output 3: Total Values by Bank and Customer Code

SELECT SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        CUSTOMER_CODE "Customer Code",
        SUM(VALUE) "Value"
FROM PD2023_WK01
GROUP BY 1,2
;



--Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction. Rename the new field with the Bank code 'Bank'

SELECT *,
    SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank"
FROM PD2023_WK01
;



--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 

SELECT *,
        SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        CASE WHEN ONLINE_OR_IN_PERSON = 1 
            THEN 'Online'
            ELSE 'In-Person'
            END "Online or In-Person"
FROM PD2023_WK01 
;



--Change the date to be the day of the week 

SELECT *,
        SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        CASE WHEN ONLINE_OR_IN_PERSON = 1 
            THEN 'Online'
            ELSE 'In-Person'
            END "Online or In-Person",
        DAYNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date"
FROM PD2023_WK01
;



--Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways

SELECT SPLIT_PART(TRANSACTION_CODE, '-', 1) "Bank",
        CASE WHEN ONLINE_OR_IN_PERSON = 1 
            THEN 'Online'
            ELSE 'In-Person'
            END "Online or In-Person",
        CUSTOMER_CODE "Customer Code",
        DAYNAME(TO_DATE(LEFT(TRANSACTION_DATE, 10), 'DD/MM/YYYY')) "Transaction Date",
        SUM(VALUE) "Value"
FROM PD2023_WK01 
GROUP BY ALL
;