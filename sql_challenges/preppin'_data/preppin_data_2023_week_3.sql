//Preppin' Data
//2023: Week 3


--Output

SELECT (CASE A.ONLINE_OR_IN_PERSON 
        WHEN '1' THEN  'Online'
        WHEN '2' THEN 'In-Person'
        END) "Online or In-Person",
        QUARTER(TO_DATE(SPLIT_PART(TRANSACTION_DATE, ' ', 1), 'DD/MM/YYYY')) "Quarter",
        SUM(VALUE) "Value",
        "Quarterly Targets",
        "Value" - "Quarterly Targets" "Variance to  Target"
FROM PD2023_WK01 A
JOIN PD2023_WK03_TARGETS B
UNPIVOT ("Quarterly Targets" FOR QUARTER IN (Q1 ,Q2 ,Q3 ,Q4))
    ON "Quarter" = TO_NUMBER(REPLACE(B.QUARTER, 'Q', ''))
    AND "Online or In-Person" = B.ONLINE_OR_IN_PERSON
WHERE TRANSACTION_CODE LIKE 'DSB%'
GROUP BY 1,2,4
;



--For the transactions file:
--Filter the transactions to just look at DSB

SELECT *
FROM PD2023_WK01
WHERE TRANSACTION_CODE LIKE 'DSB%'
;



--For the transactions file:
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values

SELECT *,
                CASE ONLINE_OR_IN_PERSON 
                WHEN '1' THEN  'Online'
                WHEN '2' THEN 'In_person'
                END AS "Online or In-Person"
FROM PD2023_WK01
WHERE TRANSACTION_CODE LIKE 'DSB%'
;



--For the transactions file:
--Change the date to be the quarter

SELECT *,
        (CASE ONLINE_OR_IN_PERSON 
        WHEN '1' THEN  'Online'
        WHEN '2' THEN 'In_person'
        END) AS "Online or In-Person",
        QUARTER(TO_DATE(SPLIT_PART(TRANSACTION_DATE, ' ', 1), 'DD/MM/YYYY')) AS "Quarter"
FROM PD2023_WK01
WHERE TRANSACTION_CODE LIKE 'DSB%'
;



--For the transactions file:
--Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person)

SELECT (CASE ONLINE_OR_IN_PERSON 
        WHEN '1' THEN  'Online'
        WHEN '2' THEN 'In_person'
        END) "Online or In-Person",
        QUARTER(TO_DATE(SPLIT_PART(TRANSACTION_DATE, ' ', 1), 'DD/MM/YYYY')) "Quarter",
        SUM(VALUE) "Value"
FROM PD2023_WK01
WHERE TRANSACTION_CODE LIKE 'DSB%'
GROUP BY ALL
;



--For the targets file:
--Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter 

SELECT * 
FROM PD2023_WK03_TARGETS
UNPIVOT ("Value" FOR QUARTER IN (Q1 ,Q2 ,Q3 ,Q4))
ORDER BY ONLINE_OR_IN_PERSON
;



--For the targets file:
--Remove the 'Q' from the quarter field and make the data type numeric

SELECT *,
        TO_NUMBER(REPLACE(QUARTER, 'Q', '')) "Quarter"
FROM PD2023_WK03_TARGETS
UNPIVOT ("Quarterly Targets" FOR QUARTER IN (Q1 ,Q2 ,Q3 ,Q4))
ORDER BY ONLINE_OR_IN_PERSON
;



--Join the two datasets together

SELECT (CASE A.ONLINE_OR_IN_PERSON 
        WHEN '1' THEN  'Online'
        WHEN '2' THEN 'In-Person'
        END) "Online or In-Person",
        QUARTER(TO_DATE(SPLIT_PART(TRANSACTION_DATE, ' ', 1), 'DD/MM/YYYY')) "Quarter",
        SUM(VALUE) "Value",
        "Quarterly Targets"
FROM PD2023_WK01 A
JOIN PD2023_WK03_TARGETS B
UNPIVOT ("Quarterly Targets" FOR QUARTER IN (Q1 ,Q2 ,Q3 ,Q4))
    ON "Quarter" = TO_NUMBER(REPLACE(B.QUARTER, 'Q', ''))
    AND "Online or In-Person" = B.ONLINE_OR_IN_PERSON
WHERE TRANSACTION_CODE LIKE 'DSB%'
GROUP BY 1,2,4
;



--Calculate the Variance to Target for each row

SELECT (CASE A.ONLINE_OR_IN_PERSON 
                    WHEN '1' THEN  'Online'
                    WHEN '2' THEN 'In-Person'
                    END) "Online or In-Person",
                    QUARTER(TO_DATE(SPLIT_PART(TRANSACTION_DATE, ' ', 1), 'DD/MM/YYYY')) "Quarter",
                    SUM(VALUE) "Value",
                    "Quarterly Targets",
                    "Value" - "Quarterly Targets" "Variance to  Target"
            FROM PD2023_WK01 A
            JOIN PD2023_WK03_TARGETS B
            UNPIVOT ("Quarterly Targets" FOR QUARTER IN (Q1 ,Q2 ,Q3 ,Q4))
                ON "Quarter" = TO_NUMBER(REPLACE(B.QUARTER, 'Q', ''))
                AND "Online or In-Person" = B.ONLINE_OR_IN_PERSON
            WHERE TRANSACTION_CODE LIKE 'DSB%'
            GROUP BY 1,2,4
;