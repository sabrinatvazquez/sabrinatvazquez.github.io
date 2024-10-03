//Preppin' Data
//2023: Week 2


--Output

SELECT TRANSACTION_ID,
        CONCAT( 'GB', CHECK_DIGITS, SWIFT_CODE, REPLACE(SORT_CODE, '-', ''), ACCOUNT_NUMBER) IBAN
FROM PD2023_WK02_TRANSACTIONS T
JOIN PD2023_WK02_SWIFT_CODES S
ON T.BANK = S.BANK
;



-- In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string

SELECT *,
        REPLACE(SORT_CODE, '-', '') SORTCODE
FROM PD2023_WK02_TRANSACTIONS
;



--Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account

SELECT *,
        REPLACE(SORT_CODE, '-', '') SORTCODE
FROM PD2023_WK02_TRANSACTIONS T
JOIN PD2023_WK02_SWIFT_CODES S
ON T.BANK = S.BANK
;



--Add a field for the Country Code

SELECT *,
        REPLACE(SORT_CODE, '-', '') SORTCODE,
        'GB' AS COUNTRY_CODE
FROM PD2023_WK02_TRANSACTIONS T
JOIN PD2023_WK02_SWIFT_CODES S
ON T.BANK = S.BANK
;



--Create the IBAN

SELECT *,
        REPLACE(SORT_CODE, '-', '') SORTCODE,
        'GB' AS COUNTRY_CODE, 
        CONCAT( COUNTRY_CODE, CHECK_DIGITS, SWIFT_CODE, SORTCODE, ACCOUNT_NUMBER) IBAN
FROM PD2023_WK02_TRANSACTIONS T
JOIN PD2023_WK02_SWIFT_CODES S
ON T.BANK = S.BANK
;



--Remove unnecessary fields

SELECT TRANSACTION_ID,
        CONCAT( 'GB', CHECK_DIGITS, SWIFT_CODE, REPLACE(SORT_CODE, '-', ''), ACCOUNT_NUMBER) IBAN
FROM PD2023_WK02_TRANSACTIONS T
JOIN PD2023_WK02_SWIFT_CODES S
ON T.BANK = S.BANK
;