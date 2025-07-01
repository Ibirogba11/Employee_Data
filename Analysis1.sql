DESCRIBE employeedata;
UPDATE employeedata
SET ExitDate = str_to_date(ExitDate, '%c/%e/%Y');

ALTER TABLE employeedata
MODIFY COLUMN ExitDate DATE;

ALTER TABLE employeedata
MODIFY COLUMN Exi	tDate DATE;

UPDATE employeedata
SET ExitDate = STR_TO_DATE(ExitDate, '%m/%d/%Y')
WHERE ExitDate IS NOT NULL;


INSERT INTO empdata
SELECT * FROM employeedata;

-- What is the gender, race, and age distribution of employees across different business units?
SELECT Unit, gender, COUNT(*) Counts
FROM empdata
GROUP BY Unit, Gender
ORDER BY Unit desc, gender asc;

SELECT Unit, Race, COUNT(*) AS Count
FROM empdata
GROUP BY Unit, Race
ORDER BY Unit desc, Race asc;


SELECT dept, TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS age, race
FROM empdata;

SELECT dept, race, COUNT(EmpID) AS Count
FROM empdata
GROUP BY dept,race
ORDER BY dept desc;

SELECT Unit,
  CASE
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) < 25 THEN '<25'
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+'
  END AS AgeGroup,
  COUNT(*) AS Count
FROM empdata
GROUP BY Unit, AgeGroup
ORDER BY AgeGroup desc, Count desc;

-- What is the average employee tenure based on age groups and employee classification types?
SELECT dept, ROUND(AVG(TIMESTAMPDIFF(MONTH, StartDate, ExitDate)),1) Average_Months
FROM empdata
WHERE ExitDate IS NOT NULL
GROUP BY dept;

-- What percentage of employees have exited the company over the last year?
SELECT 	(SELECT COUNT(EmpID) FROM empdata ) AS 'Total_Employee' ,
		Dats AS 'Exited_Emp', 
		ROUND(Dats * 100.0/	Total_Employees, 2) AS Percentage_Exit 
FROM(
SELECT 	
		COUNT(EmpID) AS Total_Employees, 
		SUM(CASE WHEN ExitDate >= DATE_SUB(MAX_Date, INTERVAL 1 YEAR) THEN 1 END) AS Dats
        FROM empdata,
(SELECT MAX(ExitDate) AS Max_Date
FROM empdata) AS L1
WHERE ExitDate IS NOT NULL) AS L2;
 
SELECT  
    (SELECT COUNT(EmpID) FROM empdata) AS Total_Employee,
    Dats AS Exited_Emp,
    ROUND(Dats * 100.0 / NULLIF((SELECT COUNT(EmpID) FROM empdata), 0), 2) AS Percentage_Exit
FROM (
    SELECT 
        SUM(CASE 
            WHEN ExitDate >= DATE_SUB(Max_Date, INTERVAL 1 YEAR) THEN 1 
            ELSE 0 
        END) AS Dats
    FROM empdata,
    (SELECT MAX(ExitDate) AS Max_Date FROM empdata) AS L1
    WHERE ExitDate IS NOT NULL
) AS L2;

-- What are the top reasons for employee exits (resignation, involuntary termination, retirement)?


select * from empdata;		
