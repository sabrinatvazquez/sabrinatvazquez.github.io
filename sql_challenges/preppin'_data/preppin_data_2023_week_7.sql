--//Preppin' Data
//2023: Week 7


--Output

WITH AI AS (SELECT *,
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 1) "ACCOUNT HOLDER 1",
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 2) "ACCOUNT HOLDER 2"
            FROM PD2023_WK07_ACCOUNT_INFORMATION)
SELECT TD.TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account To",
        TRANSACTION_DATE "Transaction Date",
        VALUE "Value",
        ACCOUNT_NUMBER "Account Number",
        ACCOUNT_TYPE "Account Type",
        BALANCE_DATE "Balance Date",
        BALANCE "Balance",
        NAME "Name",
        DATE_OF_BIRTH "Date of Birth",
        CONCAT('0',CONTACT_NUMBER) "Contact Number",
        FIRST_LINE_OF_ADDRESS "First Line of Address"
FROM AI
UNPIVOT("Account Holder" FOR HOLDER IN ("ACCOUNT HOLDER 1", "ACCOUNT HOLDER 2"))
JOIN PD2023_WK07_ACCOUNT_HOLDERS AH
    ON TRY_TO_NUMBER("Account Holder") = AH.ACCOUNT_HOLDER_ID
JOIN PD2023_WK07_TRANSACTION_PATH TP
    ON AI.ACCOUNT_NUMBER = TP.ACCOUNT_FROM
JOIN PD2023_WK07_TRANSACTION_DETAIL TD
    ON TP.TRANSACTION_ID = TD.TRANSACTION_ID
WHERE "Account Holder" <> ''
    AND CANCELLED_ = 'N'
    AND VALUE > 1000    
    AND ACCOUNT_TYPE <> 'Platinum'
;



--For the Transaction Path table:
---Make sure field naming convention matches the other tables
-----i.e. instead of Account_From it should be Account From

SELECT TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account To",
        ACCOUNT_FROM "Account From"
FROM PD2023_WK07_TRANSACTION_PATH
;



--For the Account Information table:
---Make sure there are no null values in the Account Holder ID
---Ensure there is one row per Account Holder ID
------Joint accounts will have 2 Account Holders, we want a row for each of them

WITH CTE AS (SELECT *,
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 1) "ACCOUNT HOLDER 1",
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 2) "ACCOUNT HOLDER 2"
            FROM PD2023_WK07_ACCOUNT_INFORMATION)
SELECT ACCOUNT_NUMBER,
        ACCOUNT_TYPE,
        "Account Holder",
        BALANCE_DATE,
        BALANCE
FROM CTE
UNPIVOT("Account Holder" FOR HOLDER IN ("ACCOUNT HOLDER 1", "ACCOUNT HOLDER 2"))
WHERE "Account Holder" <> ''
;



--For the Account Holders table:
---Make sure the phone numbers start with 07

SELECT *,
        CONCAT('0',CONTACT_NUMBER) "Contact Number"
FROM PD2023_WK07_ACCOUNT_HOLDERS
;



--Bring the tables together

WITH AI AS (SELECT *,
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 1) "ACCOUNT HOLDER 1",
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 2) "ACCOUNT HOLDER 2"
            FROM PD2023_WK07_ACCOUNT_INFORMATION)
SELECT TP.TRANSACTION_ID "Transaction ID",
        TP.ACCOUNT_TO "Account To",
        TD.TRANSACTION_DATE "Transaction Date",
        TD.VALUE "Value",
        ACCOUNT_NUMBER "Account Number",
        AI.ACCOUNT_TYPE "Account Type",
        BALANCE_DATE "Balance Date",
        BALANCE "Balance",
        NAME "Name",
        DATE_OF_BIRTH "Date of Birth",
        CONCAT('0',CONTACT_NUMBER) "Contact Number",
        FIRST_LINE_OF_ADDRESS "First Line of Address"
FROM AI
UNPIVOT("Account Holder" FOR HOLDER IN ("ACCOUNT HOLDER 1", "ACCOUNT HOLDER 2"))
JOIN PD2023_WK07_ACCOUNT_HOLDERS AH
    ON "Account Holder" = AH.ACCOUNT_HOLDER_ID::VARCHAR
JOIN PD2023_WK07_TRANSACTION_PATH TP
    ON AI.ACCOUNT_NUMBER = TP.ACCOUNT_FROM
JOIN PD2023_WK07_TRANSACTION_DETAIL TD
    ON TP.TRANSACTION_ID = TD.TRANSACTION_ID
WHERE "Account Holder" <> ''
;



--Filter out cancelled transactions 

WITH AI AS (SELECT *,
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 1) "ACCOUNT HOLDER 1",
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 2) "ACCOUNT HOLDER 2"
            FROM PD2023_WK07_ACCOUNT_INFORMATION)
SELECT TP.TRANSACTION_ID "Transaction ID",
        TP.ACCOUNT_TO "Account To",
        TD.TRANSACTION_DATE "Transaction Date",
        TD.VALUE "Value",
        ACCOUNT_NUMBER "Account Number",
        AI.ACCOUNT_TYPE "Account Type",
        BALANCE_DATE "Balance Date",
        BALANCE "Balance",
        NAME "Name",
        DATE_OF_BIRTH "Date of Birth",
        CONCAT('0',CONTACT_NUMBER) "Contact Number",
        FIRST_LINE_OF_ADDRESS "First Line of Address"
FROM AI
UNPIVOT("Account Holder" FOR HOLDER IN ("ACCOUNT HOLDER 1", "ACCOUNT HOLDER 2"))
JOIN PD2023_WK07_ACCOUNT_HOLDERS AH
    ON "Account Holder" = AH.ACCOUNT_HOLDER_ID::VARCHAR
JOIN PD2023_WK07_TRANSACTION_PATH TP
    ON AI.ACCOUNT_NUMBER = TP.ACCOUNT_FROM
JOIN PD2023_WK07_TRANSACTION_DETAIL TD
    ON TP.TRANSACTION_ID = TD.TRANSACTION_ID
WHERE "Account Holder" <> ''
    AND CANCELLED_ = 'N'
;



--Filter to transactions greater than £1,000 in value 

WITH AI AS (SELECT *,
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 1) "ACCOUNT HOLDER 1",
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 2) "ACCOUNT HOLDER 2"
            FROM PD2023_WK07_ACCOUNT_INFORMATION)
SELECT TP.TRANSACTION_ID "Transaction ID",
        TP.ACCOUNT_TO "Account To",
        TD.TRANSACTION_DATE "Transaction Date",
        TD.VALUE "Value",
        ACCOUNT_NUMBER "Account Number",
        AI.ACCOUNT_TYPE "Account Type",
        BALANCE_DATE "Balance Date",
        BALANCE "Balance",
        NAME "Name",
        DATE_OF_BIRTH "Date of Birth",
        CONCAT('0',CONTACT_NUMBER) "Contact Number",
        FIRST_LINE_OF_ADDRESS "First Line of Address"
FROM AI
UNPIVOT("Account Holder" FOR HOLDER IN ("ACCOUNT HOLDER 1", "ACCOUNT HOLDER 2"))
JOIN PD2023_WK07_ACCOUNT_HOLDERS AH
    ON "Account Holder" = AH.ACCOUNT_HOLDER_ID::VARCHAR
JOIN PD2023_WK07_TRANSACTION_PATH TP
    ON AI.ACCOUNT_NUMBER = TP.ACCOUNT_FROM
JOIN PD2023_WK07_TRANSACTION_DETAIL TD
    ON TP.TRANSACTION_ID = TD.TRANSACTION_ID
WHERE "Account Holder" <> ''
    AND CANCELLED_ = 'N'
    AND VALUE > 1000
;



--Filter out Platinum accounts

WITH AI AS (SELECT *,
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 1) "ACCOUNT HOLDER 1",
                    SPLIT_PART(ACCOUNT_HOLDER_ID, ', ', 2) "ACCOUNT HOLDER 2"
            FROM PD2023_WK07_ACCOUNT_INFORMATION)
SELECT TD.TRANSACTION_ID "Transaction ID",
        ACCOUNT_TO "Account To",
        TRANSACTION_DATE "Transaction Date",
        VALUE "Value",
        ACCOUNT_NUMBER "Account Number",
        ACCOUNT_TYPE "Account Type",
        BALANCE_DATE "Balance Date",
        BALANCE "Balance",
        NAME "Name",
        DATE_OF_BIRTH "Date of Birth",
        CONCAT('0',CONTACT_NUMBER) "Contact Number",
        FIRST_LINE_OF_ADDRESS "First Line of Address"
FROM AI
UNPIVOT("Account Holder" FOR HOLDER IN ("ACCOUNT HOLDER 1", "ACCOUNT HOLDER 2"))
JOIN PD2023_WK07_ACCOUNT_HOLDERS AH
    ON TRY_TO_NUMBER("Account Holder") = AH.ACCOUNT_HOLDER_ID
JOIN PD2023_WK07_TRANSACTION_PATH TP
    ON AI.ACCOUNT_NUMBER = TP.ACCOUNT_FROM
JOIN PD2023_WK07_TRANSACTION_DETAIL TD
    ON TP.TRANSACTION_ID = TD.TRANSACTION_ID
WHERE "Account Holder" <> ''
    AND CANCELLED_ = 'N'
    AND VALUE > 1000    
    AND ACCOUNT_TYPE <> 'Platinum'
;