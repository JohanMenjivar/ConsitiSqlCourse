/*************Subconsultas****************/
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=(SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME='John' and LAST_NAME='Chen');

SELECT * FROM DEPARTMENTS JOIN LOCATIONS USING(LOCATION_ID) WHERE CITY = 'Toronto'; 

SELECT  * FROM EMPLOYEES a WHERE (SELECT COUNT(*) FROM EMPLOYEES b WHERE a.EMPLOYEE_ID= b.MANAGER_ID)>5;

SELECT CITY FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID) JOIN LOCATIONS USING(LOCATION_ID) WHERE FIRST_NAME='Guy' AND LAST_NAME='Himuro';

SELECT * FROM EMPLOYEES WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEES);

SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID= ANY(SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID HAVING MAX(SALARY)>10000);

SELECT * FROM JOBS WHERE JOB_ID = ANY(SELECT JOB_ID FROM EMPLOYEES WHERE HIRE_DATE BETWEEN '01/01/2002' AND '31/12/2003');

/*************Otras subconsultas****************/

SELECT FIRST_NAME, SALARY, DEPARTMENT_ID FROM EMPLOYEES WHERE SALARY > ANY(SELECT MAX(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID IN ('50','60','70') GROUP BY DEPARTMENT_ID );

SELECT DEPARTMENT_NAME FROM DEPARTMENTS WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID HAVING AVG(SALARY) > 9000);

SELECT FIRST_NAME,DEPARTMENT_NAME,SALARY FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID) WHERE (DEPARTMENT_ID,SALARY) IN(SELECT DEPARTMENT_ID,MAX(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID) ORDER BY SALARY DESC;

SELECT FIRST_NAME, DEPARTMENT_NAME, SALARY FROM EMPLOYEES e JOIN DEPARTMENTS d ON e.DEPARTMENT_ID=d.DEPARTMENT_ID WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = e.DEPARTMENT_ID GROUP BY DEPARTMENT_ID) ORDER BY SALARY DESC;

SELECT * FROM EMPLOYEES WHERE SALARY > ALL(SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID=100);

SELECT CITY FROM LOCATIONS l WHERE EXISTS(SELECT * FROM DEPARTMENTS WHERE LOCATION_ID=l.LOCATION_ID);

SELECT REGION_NAME FROM REGIONS r WHERE NOT EXISTS( SELECT * FROM countries NATURAL JOIN LOCATIONS NATURAL JOIN DEPARTMENTS WHERE REGION_ID=r.REGION_ID); 


