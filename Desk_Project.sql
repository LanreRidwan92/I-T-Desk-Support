SELECT * FROM public.dest_support

SELECT *
FROM dest_support
LIMIT 10;


----------------------------------------------- CREATE A DUPLICATE TABLE FOR THE EDA ------------------------------------------

CREATE TABLE desk_sup 
(LIKE dest_support INCLUDING ALL);


-------------------------------------------- POPULATE DATA INTO THE NEW TABLE CREATED ------------------------------------------

INSERT INTO desk_sup
	SELECT *
	FROM dest_support;


------------------------------------------ CHECKING THE DUPLICATE VALUES IN THE NEW TABLE CREATED ------------------------------------------

SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY "Ticket_ID","Date","Resolution_Date","Subject","Body","Answer","Type","Type","Queue","Priority",
	"Primary_Tag","Secondary_Tag","Category","Technical","Status","Resolution","Documentation","Additional","Country"
	) AS Row_Num
FROM desk_sup;


WITH CTE_desk_dup AS 
(
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY "Ticket_ID","Date","Resolution_Date","Subject","Body","Answer","Type","Type","Queue","Priority",
	"Primary_Tag","Secondary_Tag","Category","Technical","Status","Resolution","Documentation","Additional","Country"
	) AS Row_Num
	FROM desk_sup
)
SELECT *
FROM CTE_desk_dup 
	WHERE Row_Num > 1


------------------------------------------ CHECKING THE EMPTY VALUES IN THE NEW TABLE CREATED ------------------------------------------

SELECT *
FROM desK_sup
WHERE "Date" IS NULL;

SELECT *
FROM desK_sup
WHERE "Resolution_Date" IS NULL;

SELECT *
FROM desK_sup
WHERE "Subject" IS NULL;

SELECT *
FROM desK_sup
WHERE "Body" IS NULL;

SELECT *
FROM desK_sup
WHERE "Type" IS NULL;

SELECT *
FROM desK_sup
WHERE "Queue" IS NULL;

SELECT *
FROM desK_sup
WHERE "Documentation" IS NULL;

SELECT *
FROM desK_sup
WHERE "Additional" IS NULL;

SELECT *
FROM desK_sup
WHERE "Country" IS NULL;


-------------------------------------- REMOVING SOME IRRELEVANT COLUMNS IN THE NEW TABLE CREATED ---------------------------------------

ALTER TABLE desk_sup
	DROP COLUMN "Subject",
	DROP COLUMN "Body",
	DROP COLUMN "Answer";
	

------------------------------------------ FORMAT DATE COLUMN FROM TEXT TO DATE VALUE IN THE NEW TABLE CREATED ------------------------------------------

SELECT TO_DATE("Date", 'MM-DD-YYYY')
	AS Date_Formatted
	FROM desk_sup;


SELECT TO_DATE("Resolution_Date", 'MM-DD-YYYY')
	AS Resolution_Date_Formatted
	FROM desk_sup;



--------------------------------------- UPDATING THE FORMATTED DATE INTO THE TABLE AS NEW COLUMN ------------------------------------------

ALTER TABLE desk_sup
	ADD COLUMN Datett DATE;

UPDATE desk_sup
	SET Datett = TO_DATE("Date", 'MM-DD-YYYY');


ALTER TABLE desk_sup
	ADD COLUMN Resolution_Date_Formatted DATE;

UPDATE desk_sup
	SET Resolution_Date_Formatted = TO_DATE("Resolution_Date", 'MM-DD-YYYY');



---------------------------------------------- REMOVING THE OTHER DATE ------------------------------------------------------

ALTER TABLE desk_sup
	DROP "Date";

ALTER TABLE desk_sup
	DROP "Resolution_Date";


---------------------------------------------- CAPITALIZE THE FIRST LETTER OF THE PRIORITY COLUMN ------------------------------------------------------

SELECT INITCAP("Priority") 
	FROM desk_sup;

UPDATE desk_sup
SET "Priority" = INITCAP("Priority")
WHERE "Priority" != INITCAP("Priority");


---------------------------------------------- CHECK THE DISTINCT VALUES IN EACH COLUMNS ------------------------------------------------------

SELECT DISTINCT ("Type")
	FROM desk_sup;
	
SELECT DISTINCT ("Queue")
	FROM desk_sup;
	
SELECT DISTINCT ("Priority")
	FROM desk_sup;
	
SELECT DISTINCT ("Primary_Tag")
	FROM desk_sup;
	
SELECT DISTINCT ("Secondary_Tag")
	FROM desk_sup;
	
SELECT DISTINCT ("Category")
	FROM desk_sup;
	
SELECT DISTINCT ("Technical")
	FROM desk_sup;
	
SELECT DISTINCT ("Status")
	FROM desk_sup;
	
SELECT DISTINCT ("Resolution")
	FROM desk_sup;
	
SELECT DISTINCT ("Documentation")
	FROM desk_sup;
	
SELECT DISTINCT ("Additional")
	FROM desk_sup;
	
SELECT DISTINCT ("Country")
	FROM desk_sup;
	

----------------------------------------- THE MOST COMMON ISSUES PEOPLE COMPLAIN MOST ------------------------------------------------------

SELECT DISTINCT ("Type"),
	COUNT("Type") AS Total_Issue
	FROM desk_sup
	GROUP BY "Type"
	ORDER BY Total_Issue DESC;


----------------------------------------- TOTAL TICKETS HANDLED BY SUPPORT TEAMS ------------------------------------------------------


SELECT DISTINCT ("Queue"),
	COUNT("Ticket_ID") AS Total_Ticket
	FROM desk_sup
	GROUP BY "Queue"
	ORDER BY Total_Ticket DESC;


--------------------------------------------- HOW DIFFERENT TAGS WERE USED ------------------------------------------------------

SELECT DISTINCT  ("Primary_Tag"),
	COUNT("Primary_Tag") AS Total_Tag
	FROM desk_sup
	GROUP BY "Primary_Tag"
	ORDER BY Total_Tag DESC
	LIMIT 10;



--------------------------------------------- AVERAGE DAYS TOOK BEFORE IT WAS RESOLVED ------------------------------------------------------

SELECT AVG("Date" - "resolution_date_formatted") AS avg_resolution_time
FROM desk_sup
WHERE resolution_date_formatted IS NOT NULL;



--------------------------------------------- AVERAGE DAYS TOOK BEFORE IT WAS RESOLVED ------------------------------------------------------

SELECT "Priority",
       AVG(EXTRACT(EPOCH FROM "resolution_date_formatted" - "Date") / 3600) AS Avg_Resolution_Hours
FROM desk_sup
WHERE resolution_date_formatted IS NOT NULL
GROUP BY "Priority"
ORDER BY Avg_Resolution_Hours;





--------------------------------------------- TOTAL TICKET RESOLVED BY TICKET CATEGORY ------------------------------------------------------

SELECT "Priority", AVG("Date" - "resolution_date_formatted") AS avg_resolution_time
FROM desk_sup
WHERE resolution_date_formatted IS NOT NULL
	GROUP BY "Priority";


------------------------------------------- TOTAL TICKET SUBMITTED BY COUNTRIES ------------------------------------------------------

SELECT "Country",
	COUNT("Ticket_ID") AS Total_Ticket_Submitted
FROM desk_sup
	GROUP BY "Country"
	ORDER BY Total_Ticket_Submitted DESC;
	

------------------------------------------- COUNTRIES THAT EXPERIENCE DELAY ------------------------------------------------------


SELECT "Country", AVG("Date" - "resolution_date_formatted") AS avg_resolution_time
FROM desk_sup
WHERE resolution_date_formatted IS NOT NULL
	GROUP BY "Country"
	ORDER BY avg_resolution_time DESC;


------------------------------------------- TYPE OF ISSUES EXPERIENCE BY COUNTRIES ------------------------------------------------------


SELECT "Country", COUNT("Type") AS Total_Problem_Issues
FROM desk_sup
WHERE "Type" = 'Problem'
	GROUP BY "Country"
	ORDER BY  Total_Problem_Issues DESC;



SELECT "Country", COUNT("Type") AS Total_Request
FROM desk_sup
WHERE "Type" = 'Request'
	GROUP BY "Country"
	ORDER BY Total_Request DESC;


SELECT "Country", COUNT("Type") AS Total_Incident
FROM desk_sup
WHERE "Type" = 'Incident'
	GROUP BY "Country"
	ORDER BY Total_Incident DESC;







SELECT *
FROM desk_sup
LIMIT 5;
