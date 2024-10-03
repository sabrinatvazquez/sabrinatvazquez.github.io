------Data with Danny
-----Case Study 3
----Foodie-Fi



-----A. Customer Journey


--A 1 
---Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

SELECT CUSTOMER_ID,
        PLAN_NAME,
        PRICE,
        START_DATE
FROM SUBSCRIPTIONS S
JOIN PLANS P
   ON S.PLAN_ID = P.PLAN_ID
WHERE CUSTOMER_ID IN (1,2,11,13,15,16,18,19)
;