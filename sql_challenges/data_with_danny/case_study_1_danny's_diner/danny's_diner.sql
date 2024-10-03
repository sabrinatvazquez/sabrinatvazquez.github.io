--Data with Danny
--Case Study 1
--Danny's Diner


--1 What is the total amount each customer spent at the restaurant?

SELECT S.CUSTOMER_ID,
        SUM(M.PRICE) TOTAL
FROM SALES AS S
JOIN MENU AS M
    ON S. PRODUCT_ID = M.PRODUCT_ID
GROUP BY S.CUSTOMER_ID
;



--2 How many days has each customer visited the restaurant?

SELECT CUSTOMER_ID,
        COUNT(DISTINCT ORDER_DATE) DAYS
FROM SALES
GROUP BY CUSTOMER_ID
;



--3 What was the first item from the menu purchased by each customer?

 WITH CTE AS (SELECT  S.CUSTOMER_ID,
                    MIN(S.ORDER_DATE) MIN
            FROM SALES S
            GROUP BY ALL)
SELECT CTE.CUSTOMER_ID,
        P.PRODUCT_NAME
FROM CTE
JOIN SALES S
    ON CTE.CUSTOMER_ID = S.CUSTOMER_ID
    AND S.ORDER_DATE = MIN
JOIN MENU P
    ON S.PRODUCT_ID = P.PRODUCT_ID
;



--4 What is the most purchased item on the menu and how many times was it purchased by all customers?

WITH CTE AS (SELECT M.PRODUCT_NAME,
                    M.PRODUCT_ID,
                    COUNT(S.PRODUCT_ID) AS TOTAL
            FROM SALES AS S
            JOIN MENU AS M
                ON S.PRODUCT_ID = M.PRODUCT_ID
            GROUP BY 1,2
            ORDER BY TOTAL DESC
            LIMIT 1),
    CTE2 AS (SELECT S.CUSTOMER_ID,
                    CTE.PRODUCT_NAME,
                    CTE.PRODUCT_ID,
                    TOTAL
                FROM CTE
                JOIN SALES S 
                    ON CTE.PRODUCT_ID = S.PRODUCT_ID
                    GROUP BY ALL),
    CTE3 AS (SELECT S.CUSTOMER_ID,
                    S.PRODUCT_ID,
                    COUNT(PRODUCT_ID) "COUNT"
                FROM SALES S
                GROUP BY ALL)
SELECT CTE2.PRODUCT_NAME,
       CTE2.TOTAL,
       CTE2.CUSTOMER_ID,
       CTE3."COUNT"
FROM CTE3
JOIN CTE2 
    ON CTE3.CUSTOMER_ID = CTE2.CUSTOMER_ID
    AND CTE3.PRODUCT_ID = CTE2.PRODUCT_ID
;



-- 5 Which item was the most popular for each customer?

WITH CTE AS (SELECT S.CUSTOMER_ID,
            P.PRODUCT_NAME,
            COUNT(P.PRODUCT_ID) "ITEM#"
                FROM SALES S
                JOIN MENU P
                    ON S.PRODUCT_ID = P.PRODUCT_ID
                GROUP BY ALL),
    CTE2 AS (SELECT CUSTOMER_ID,
             MAX("ITEM#") "MAX"
            FROM CTE
            GROUP BY 1)
SELECT CTE2.CUSTOMER_ID, 
        CTE.PRODUCT_NAME
FROM CTE2
JOIN CTE 
ON CTE2.CUSTOMER_ID = CTE.CUSTOMER_ID
    AND CTE2.MAX = CTE."ITEM#"
;



-- 6 Which item was purchased first by the customer after they became a member?

WITH CTE AS (SELECT M.*,
                    S.ORDER_DATE,
                    P.PRODUCT_NAME
            FROM MEMBERS M
            JOIN SALES S
                ON M.CUSTOMER_ID = S.CUSTOMER_ID
            JOIN MENU P
                ON S.PRODUCT_ID = P.PRODUCT_ID
             WHERE JOIN_DATE < ORDER_DATE),
     CTE2 AS (SELECT CUSTOMER_ID, 
                MIN(ORDER_DATE) MIN
                FROM CTE
                GROUP BY 1)
SELECT CTE2.CUSTOMER_ID,
        CTE.PRODUCT_NAME
FROM CTE2
JOIN CTE 
ON CTE2.CUSTOMER_ID = CTE.CUSTOMER_ID
AND MIN = CTE.ORDER_DATE
;



--7 Which item was purchased just before the customer became a member?

WITH CTE AS (SELECT M.*,
                    S.ORDER_DATE,
                    P.PRODUCT_NAME
            FROM MEMBERS M
            JOIN SALES S
                ON M.CUSTOMER_ID = S.CUSTOMER_ID
            JOIN MENU P
                ON S.PRODUCT_ID = P.PRODUCT_ID
             WHERE JOIN_DATE > ORDER_DATE),
     CTE2 AS (SELECT CUSTOMER_ID, 
                MAX(ORDER_DATE) MAX
                FROM CTE
                GROUP BY 1)
SELECT CTE2.CUSTOMER_ID,
        CTE.PRODUCT_NAME
FROM CTE2
JOIN CTE 
ON CTE2.CUSTOMER_ID = CTE.CUSTOMER_ID
AND MAX = CTE.ORDER_DATE
ORDER BY CUSTOMER_ID
;



--8 What is the total items and amount spent for each member before they became a member?

SELECT M.CUSTOMER_ID,
        COUNT(PRODUCT_NAME) ITEMS,
        SUM(P.PRICE) SPENT
FROM MEMBERS M
JOIN SALES S
    ON M.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MENU P
    ON S.PRODUCT_ID = P.PRODUCT_ID
WHERE JOIN_DATE > ORDER_DATE
GROUP BY 1
;



--9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT S.CUSTOMER_ID,
        SUM(M.PRICE *10 * CASE WHEN PRODUCT_NAME = 'sushi'
            THEN 2
            ELSE 1
            END) AS POINTS
FROM SALES AS S
JOIN MENU AS M
    ON S. PRODUCT_ID = M.PRODUCT_ID
GROUP BY S.CUSTOMER_ID
;



--10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH CTE AS (SELECT M.*,
                    S.ORDER_DATE,
                    P.PRODUCT_NAME,
                    P.PRICE,
                    PRICE *10 * 2 POINTS
            FROM MEMBERS M
            JOIN SALES S
                ON M.CUSTOMER_ID = S.CUSTOMER_ID
            JOIN MENU P
                ON S.PRODUCT_ID = P.PRODUCT_ID
             WHERE JOIN_DATE <= ORDER_DATE
             AND ORDER_DATE <= DATEADD("day", 7, JOIN_DATE))
SELECT CTE.CUSTOMER_ID, 
        SUM(POINTS)
FROM CTE
GROUP BY 1
;