------Data with Danny
-----Case Study 2
----Pizza Runner



-----C. Ingredient Optimization


--C 1 
---What are the standard ingredients for each pizza?

WITH CTE AS (SELECT PIZZA_ID,
                    VALUE TOPPINGS
            FROM PIZZA_RECIPES R, LATERAL SPLIT_TO_TABLE(R.TOPPINGS, ', '))
SELECT  PIZZA_NAME "PIZZA",
        LISTAGG (TOPPING_NAME, ', ') "STANDARD TOPPINGS"
FROM CTE
JOIN PIZZA_NAMES N
    ON CTE.PIZZA_ID = N.PIZZA_ID
JOIN PIZZA_TOPPINGS T 
    ON TOPPING_ID = CTE.TOPPINGS
GROUP BY 1
ORDER BY 1
;



--C 2 
---What was the most commonly added extra?

WITH CTE AS (SELECT  VALUE "PIZZA EXTRA",
                    COUNT(EXTRAS) "TIMES ADDED"
            FROM CUSTOMER_ORDERS C, LATERAL SPLIT_TO_TABLE(C.EXTRAS, ', ')
            WHERE EXTRAS <> ''
                    AND EXTRAS <> 'null'
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1)
SELECT TOPPING_NAME,
       "TIMES ADDED"
FROM CTE
JOIN PIZZA_TOPPINGS T
    ON "PIZZA EXTRA" = TOPPING_ID
;



--C 3 
---What was the most common exclusion?

WITH CTE AS (SELECT  VALUE "PIZZA EXCLUSION",
                    COUNT(EXCLUSIONS) "TIMES EXCLUDED"
            FROM CUSTOMER_ORDERS C, LATERAL SPLIT_TO_TABLE(C.EXCLUSIONS, ', ')
            WHERE EXCLUSIONS <> ''
                    AND EXCLUSIONS <> 'null'
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1)
SELECT TOPPING_NAME,
       "TIMES EXCLUDED"
FROM CTE
JOIN PIZZA_TOPPINGS T
    ON "PIZZA EXCLUSION" = TOPPING_ID
;



--C 4
---Generate an order item for each record in the customers_orders table in the format of one of the following:
----Meat Lovers
----Meat Lovers - Exclude Beef
----Meat Lovers - Extra Bacon
----Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH ORDERS AS (SELECT *,
                        ROW_NUMBER() OVER (ORDER BY ORDER_ID, PIZZA_ID) RN
                FROM CUSTOMER_ORDERS),
        LESS AS (SELECT  DISTINCT RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        ORDERS.EXCLUSIONS,
                        EX.VALUE "PIZZA EXCLUSION",
                        T.TOPPING_NAME EXCLUDED
                FROM ORDERS
                JOIN CUSTOMER_ORDERS C
                        ON ORDERS.ORDER_ID = C.ORDER_ID
                        AND ORDERS.PIZZA_ID = C.PIZZA_ID
                JOIN LATERAL SPLIT_TO_TABLE(REPLACE(ORDERS.EXCLUSIONS, 'null', ''), ', ') EX
                JOIN PIZZA_TOPPINGS T
                    ON TRY_TO_NUMBER("PIZZA EXCLUSION") = T.TOPPING_ID
                GROUP BY ALL
                ORDER BY 1),
        PLUS AS (SELECT  DISTINCT RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        ORDERS.EXTRAS,
                        ADD.VALUE "PIZZA EXTRA",
                        T.TOPPING_NAME ADDED
                FROM ORDERS
                LEFT JOIN CUSTOMER_ORDERS C
                        ON ORDERS.ORDER_ID = C.ORDER_ID
                        AND ORDERS.PIZZA_ID = C.PIZZA_ID
                JOIN LATERAL SPLIT_TO_TABLE(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ') ADD
                JOIN PIZZA_TOPPINGS T
                    ON TRY_TO_NUMBER("PIZZA EXTRA") = T.TOPPING_ID
                GROUP BY ALL
                ORDER BY 1)
SELECT ORDERS.ORDER_ID, 
        CONCAT(N.PIZZA_NAME,
                            CASE LISTAGG (DISTINCT EXCLUDED, ', ')
                            WHEN '' THEN ''
                            ELSE ' - Exclude '
                            END,                                    LISTAGG (DISTINCT EXCLUDED, ', '), CASE LISTAGG (DISTINCT ADDED, ', ')
                                                                    WHEN '' THEN ''
                                                                    ELSE ' - Extra '
                                                                    END,                                                                   LISTAGG (DISTINCT ADDED, ', ')) "ORDER ITEM"
FROM ORDERS
LEFT JOIN LESS
    ON ORDERS.RN = LESS.RN
LEFT JOIN PLUS
    ON ORDERS.RN = PLUS.RN
JOIN PIZZA_NAMES N
    ON ORDERS.PIZZA_ID = N.PIZZA_ID
GROUP BY 1, N.PIZZA_NAME, ORDERS.RN
ORDER BY 1, ORDERS.RN
;



--C 5
---Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
----"Meat Lovers: 2xBacon, Beef, ... , Salami"

WITH ORDERS AS (SELECT *,
                        ROW_NUMBER() OVER (ORDER BY ORDER_ID, PIZZA_ID) RN
                FROM CUSTOMER_ORDERS),
        LESS AS (SELECT ORDERS.RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        ORDERS.EXCLUSIONS,
                        SPLIT_PART(REPLACE(ORDERS.EXCLUSIONS, 'null', ''), ', ', 1) EX1,
                        SPLIT_PART(REPLACE(ORDERS.EXCLUSIONS, 'null', ''), ', ', 2) EX2,
                        R.TOPPINGS,
                        CONTAINS (CONCAT(' ', R.TOPPINGS, ',') , CASE  
                                                                    WHEN EX1 <> '' THEN CONCAT(' ', EX1, ', ') 
                                                                    ELSE NULL 
                                                                    END) CONTAINSEX1,
                        CONTAINS (CONCAT(' ', R.TOPPINGS, ',') , CASE 
                                                                    WHEN EX1 <> '' THEN CONCAT(' ', EX2, ', ') 
                                                                    ELSE NULL 
                                                                    END) CONTAINSEX2,
                        CASE 
                            WHEN CONTAINSEX1 = TRUE THEN REPLACE(TOPPINGS, CONCAT (EX1, ', '), '') 
                            ELSE TOPPINGS 
                            END TOPPINGSEX1,
                        CASE 
                            WHEN CONTAINSEX2 = TRUE THEN REPLACE(TOPPINGSEX1, CONCAT (EX2, ', '), '') 
                            ELSE TOPPINGSEX1 
                            END TOPPINGSEX2
                FROM ORDERS
                JOIN CUSTOMER_ORDERS C
                    ON ORDERS.ORDER_ID = C.ORDER_ID
                    AND ORDERS.PIZZA_ID = C.PIZZA_ID
                JOIN PIZZA_RECIPES R
                ON ORDERS.PIZZA_ID = R.PIZZA_ID
                GROUP BY ALL
                ORDER BY 1),
        PLUS AS (SELECT ORDERS.RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        TOPPINGSEX2,
                        CASE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 1)
                            WHEN '' THEN NULL 
                            ELSE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 1) 
                            END ADD1,
                        CASE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 2)
                            WHEN '' THEN NULL 
                            ELSE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 2) 
                            END ADD2,
                        CASE 
                            WHEN (CONTAINS (CONCAT(' ', TOPPINGSEX2, ',') , CASE WHEN ADD1 <> '' THEN CONCAT(' ', ADD1, ', ') ELSE NULL END)) = 'FALSE' THEN CONCAT(ADD1, ', ', TOPPINGSEX2)
                            WHEN (CONTAINS (CONCAT(' ', TOPPINGSEX2, ',') , CASE WHEN ADD2 <> '' THEN CONCAT(' ', ADD1, ', ') ELSE NULL END)) = 'FALSE' THEN CONCAT(ADD2, ', ', TOPPINGSEX2)
                            ELSE TOPPINGSEX2 
                            END ADJTOPPINGS
                FROM ORDERS
                JOIN LESS
                    ON ORDERS.RN = LESS.RN
                JOIN CUSTOMER_ORDERS C
                        ON ORDERS.ORDER_ID = C.ORDER_ID
                        AND ORDERS.PIZZA_ID = C.PIZZA_ID
                GROUP BY ALL
                ORDER BY 1),
 TOPPINGCTE AS (SELECT ORDERS.RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        ADD1,
                        ADD2,
                        ADJTOPPINGS, 
                        TOPSTABLE.VALUE TOPS,
                        T.TOPPING_NAME TOPSLIST,
                        CONTAINS(CONCAT(' ', TOPS, ' '), CONCAT(' ', ADD1, ' ')) CONTAINSADD1,
                        CONTAINS(CONCAT(' ', TOPS, ' '), CONCAT(' ', ADD2, ' ')) CONTAINSADD2,
                        CASE 
                            WHEN CONTAINSADD2 = TRUE THEN CONCAT( '2x', TOPSLIST)
                            WHEN CONTAINSADD1 = TRUE THEN CONCAT( '2x', TOPSLIST)
                            ELSE TOPSLIST 
                            END TOPSMENU
                FROM PLUS
                JOIN ORDERS
                    ON PLUS.RN = ORDERS.RN
                JOIN LATERAL SPLIT_TO_TABLE(ADJTOPPINGS, ', ') TOPSTABLE
                JOIN PIZZA_TOPPINGS T
                    ON TOPS = T.TOPPING_ID
                GROUP BY ALL
                ORDER BY 1,2,TOPSMENU)
SELECT ORDERS.ORDER_ID,
        CONCAT( CASE N.PIZZA_ID
                WHEN 1 THEN 'Meat Lovers'
                ELSE N.PIZZA_NAME 
                END
                                          , ': ', LISTAGG (TOPSMENU, ', ')) MENU
FROM TOPPINGCTE
JOIN ORDERS 
    ON TOPPINGCTE.RN = ORDERS.RN
JOIN PIZZA_NAMES N
    ON ORDERS.PIZZA_ID = N.PIZZA_ID
GROUP BY 1, ORDERS.RN, N.PIZZA_ID, N.PIZZA_NAME
ORDER BY 1, N.PIZZA_NAME
;



--C 6
---What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

WITH ORDERS AS (SELECT *,
                        ROW_NUMBER() OVER (ORDER BY ORDER_ID, PIZZA_ID) RN
                FROM CUSTOMER_ORDERS),
        LESS AS (SELECT ORDERS.RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        ORDERS.EXCLUSIONS,
                        SPLIT_PART(REPLACE(ORDERS.EXCLUSIONS, 'null', ''), ', ', 1) EX1,
                        SPLIT_PART(REPLACE(ORDERS.EXCLUSIONS, 'null', ''), ', ', 2) EX2,
                        R.TOPPINGS,
                        CONTAINS (CONCAT(' ', R.TOPPINGS, ',') , CASE  
                                                                    WHEN EX1 <> '' THEN CONCAT(' ', EX1, ', ') 
                                                                    ELSE NULL 
                                                                    END) CONTAINSEX1,
                        CONTAINS (CONCAT(' ', R.TOPPINGS, ',') , CASE 
                                                                    WHEN EX1 <> '' THEN CONCAT(' ', EX2, ', ') 
                                                                    ELSE NULL 
                                                                    END) CONTAINSEX2,
                        CASE 
                            WHEN CONTAINSEX1 = TRUE THEN REPLACE(TOPPINGS, CONCAT (EX1, ', '), '') 
                            ELSE TOPPINGS 
                            END TOPPINGSEX1,
                        CASE 
                            WHEN CONTAINSEX2 = TRUE THEN REPLACE(TOPPINGSEX1, CONCAT (EX2, ', '), '') 
                            ELSE TOPPINGSEX1 
                            END TOPPINGSEX2
                FROM ORDERS
                JOIN CUSTOMER_ORDERS C
                    ON ORDERS.ORDER_ID = C.ORDER_ID
                    AND ORDERS.PIZZA_ID = C.PIZZA_ID
                JOIN PIZZA_RECIPES R
                ON ORDERS.PIZZA_ID = R.PIZZA_ID
                GROUP BY ALL
                ORDER BY 1),
        PLUS AS (SELECT ORDERS.RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        TOPPINGSEX2,
                        CASE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 1)
                            WHEN '' THEN NULL 
                            ELSE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 1) 
                            END ADD1,
                        CASE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 2)
                            WHEN '' THEN NULL 
                            ELSE SPLIT_PART(REPLACE(ORDERS.EXTRAS, 'null', ''), ', ', 2) 
                            END ADD2,
                        CASE 
                            WHEN (CONTAINS (CONCAT(' ', TOPPINGSEX2, ',') , CASE WHEN ADD1 <> '' THEN CONCAT(' ', ADD1, ', ') ELSE NULL END)) = 'FALSE' THEN CONCAT(ADD1, ', ', TOPPINGSEX2)
                            WHEN (CONTAINS (CONCAT(' ', TOPPINGSEX2, ',') , CASE WHEN ADD2 <> '' THEN CONCAT(' ', ADD1, ', ') ELSE NULL END)) = 'FALSE' THEN CONCAT(ADD2, ', ', TOPPINGSEX2)
                            ELSE TOPPINGSEX2 
                            END ADJTOPPINGS
                FROM ORDERS
                JOIN LESS
                    ON ORDERS.RN = LESS.RN
                JOIN CUSTOMER_ORDERS C
                        ON ORDERS.ORDER_ID = C.ORDER_ID
                        AND ORDERS.PIZZA_ID = C.PIZZA_ID
                GROUP BY ALL
                ORDER BY 1),
TOPPINGSCTE AS (SELECT ORDERS.RN,
                        ORDERS.ORDER_ID,
                        ORDERS.PIZZA_ID,
                        ADD1,
                        ADD2,
                        TOPSTABLE.VALUE TOPS,
                        -- T.TOPPING_NAME TOPSLIST,
                        CONTAINS(CONCAT(' ', TOPS, ' '), CONCAT(' ', ADD1, ' ')) CONTAINSADD1,
                        CONTAINS(CONCAT(' ', TOPS, ' '), CONCAT(' ', ADD2, ' ')) CONTAINSADD2,
                        CASE 
                            WHEN CONTAINSADD2 = TRUE THEN 2
                            WHEN CONTAINSADD1 = TRUE THEN 2
                            ELSE 1 
                            END TOPSX
                FROM PLUS
                JOIN ORDERS
                    ON PLUS.RN = ORDERS.RN
                JOIN LATERAL SPLIT_TO_TABLE(ADJTOPPINGS, ', ') TOPSTABLE
                JOIN RUNNER_ORDERS RO
                    ON ORDERS.ORDER_ID = RO.ORDER_ID
                WHERE PICKUP_TIME <> 'null'
                GROUP BY ALL
                ORDER BY 1,2),
    COUNTTOPS AS (SELECT TOPS,
                        TOPSX,
                        COUNT(TOPS) COUNT,
                        (TOPSX * COUNT) ALLTOPS
                FROM TOPPINGSCTE
                GROUP BY ALL)
SELECT TOPPING_NAME TOPPING,
        SUM(ALLTOPS) COUNT
FROM COUNTTOPS
JOIN PIZZA_TOPPINGS T
    ON TOPS = T.TOPPING_ID
GROUP BY 1
ORDER BY SUM(ALLTOPS) DESC
;