--SQL Murder Mystery

--A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City. Start by retrieving the corresponding crime scene report from the police department’s database.


-- CRIME SCENE REPORT

SELECT * 
FROM CRIME_SCENE_REPORT
WHERE UPPER(TYPE) = 'MURDER'
AND UPPER(CITY) = 'SQL CITY'
AND DATE = '20180115'
;
        /*
        Security footage shows that there were 2 witnesses. 
        The first witness lives at the last house on "Northwestern Dr". 
        The second witness, named Annabel, lives somewhere on   "Franklin Ave".
        */



----WITNESS 1 INFO

SELECT * ,
MAX(ADDRESS_NUMBER)
FROM PERSON
WHERE UPPER(ADDRESS_STREET_NAME) = 'NORTHWESTERN DR'
;
        /* 
        id	name	license_id	address_number	address_street_name	ssn	
        14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949
        */



----WITNESS 2 INFO

SELECT * 
FROM PERSON
WHERE UPPER(ADDRESS_STREET_NAME) = 'FRANKLIN AVE'
AND UPPER(NAME) LIKE '%ANNABEL%'
;

        /* 
        id	name	license_id	address_number	address_street_name	ssn
        16371	Annabel Miller	490173	103	Franklin Ave	318771143
        */

        

-- INTERVIEW INFO FROM WITNESSES

SELECT * 
FROM INTERVIEW
WHERE PERSON_ID = 14887
	OR PERSON_ID = 16371
;
        /*
        person_id	
        transcript
        
        14887	
        I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
        The membership number on the bag started with "48Z". 
        Only gold members have those bags. 
        The man got into a car with a plate that included "H42W".
        
        16371	
        I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
        */

        
        
--FIND MURDERER

SELECT C.NAME 
FROM GET_FIT_NOW_MEMBER AS A
JOIN GET_FIT_NOW_CHECK_IN AS B
ON A.ID = B.MEMBERSHIP_ID
JOIN PERSON AS C
	ON A.PERSON_ID = C.ID
JOIN DRIVERS_LICENSE AS D
ON C.LICENSE_ID = D.ID
WHERE A.ID LIKE '48Z%'
	AND UPPER(MEMBERSHIP_STATUS) = 'GOLD'
	AND PLATE_NUMBER LIKE '%H42W%'
	AND CHECK_IN_DATE = '20180109'



--EXTRA! Who is actually behind the crime?

--MURDERER'S INTERVIEW INFO

SELECT *
FROM INTERVIEW
WHERE PERSON_ID = 67318
;

        /*
        person_id	
        transcript
        
        67318	
        I was hired by a woman with a lot of money. 
        I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
        She has red hair and she drives a Tesla Model S. 
        I know that she attended the SQL Symphony Concert 3 times in December 2017.
        */

        

--FIND WHO HIRED MURDERER

SELECT NAME
FROM DRIVERS_LICENSE A
JOIN PERSON B
ON A.ID = B.LICENSE_ID
JOIN FACEBOOK_EVENT_CHECKIN C
ON B.ID = C.PERSON_ID
WHERE UPPER(GENDER) = 'FEMALE'
	AND (HEIGHT > 65
	OR HEIGHT < 67)
	AND UPPER(HAIR_COLOR) = 'RED'
	AND UPPER(CAR_MAKE) = 'TESLA'
	AND UPPER(CAR_MODEL) = 'MODEL S'
	AND UPPER(EVENT_NAME) = 'SQL SYMPHONY CONCERT'
	AND DATE LIKE '201712%'
GROUP BY NAME
HAVING COUNT(EVENT_NAME) = 3
;