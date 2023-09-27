-- INLINE VIEWS

CREATE VIEW VISTA_EMPLE AS SELECT * FROM EMPLOYEES ORDER BY SALARY DESC;

SELECT FIRST_NAME,SALARY FROM VISTA_EMPLE WHERE SALARY > 5000;

SELECT FIRST_NAME,SALARY FROM (SELECT * FROM EMPLOYEES ORDER BY SALARY DESC) WHERE SALARY > 5000;

CREATE TABLE REGIONES1 AS SELECT * FROM REGIONS;

SELECT * FROM REGIONES1;

CREATE VIEW VIEW_REGIONES AS SELECT * FROM REGIONES1;

INSERT INTO VIEW_REGIONES VALUES(5,'ANTARTICA');

INSERT INTO (SELECT * FROM REGIONES1) VALUES(6,'AUSTRALIA');

UPDATE (SELECT * FROM REGIONES1 WHERE REGION_ID> 3)  SET REGION_NAME=LOWER(REGION_NAME);
SELECT * FROM REGIONES1;

/******insert all*******/
DROP TABLE NOM_EMPLES;
DROP TABLE SALARIOS;

CREATE TABLE NOM_EMPLES (COD_EMPLE NUMBER, FIRST_NAME VARCHAR2(100));

CREATE TABLE SALARIOS (COD_EMPLE NUMBER, SALARY NUMBER);

INSERT ALL
   INTO NOM_EMPLES VALUES (EMPLOYEE_ID,FIRST_NAME)
   INTO SALARIOS VALUES (EMPLOYEE_ID,SALARY)
SELECT * FROM EMPLOYEES;

SELECT * FROM NOM_EMPLES;
SELECT * FROM SALARIOS;



INSERT ALL
   INTO NOM_EMPLES VALUES (1,'HOLA')
   INTO SALARIOS VALUES (1,100)
SELECT 1 FROM DUAL;


/**********insert condicionales*************/
--insert all
DROP TABLE EMPLES_JEFES;
DROP TABLE EMPLES_MANDOS;
DROP TABLE EMPLES_NORMALES;
DROP TABLE FINANCIERO;
CREATE TABLE EMPLES_JEFES (COD_EMPLE NUMBER, NOMBRE VARCHAR2(100), SALARIO NUMBER);
CREATE TABLE EMPLES_MANDOS (COD_EMPLE NUMBER, NOMBRE VARCHAR2(100), SALARIO NUMBER,DEPARTAMENTO NUMBER);
CREATE TABLE EMPLES_NORMALES (COD_EMPLE NUMBER, NOMBRE VARCHAR2(100), SALARIO NUMBER,RESPONSABLE NUMBER);
CREATE TABLE FINANCIERO (COD_EMPLE NUMBER, NOMBRE VARCHAR2(100), SALARIO NUMBER,RESPONSABLE NUMBER);
INSERT ALL
    WHEN SALARY > 10000 THEN
        INTO EMPLES_JEFES VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY)
     WHEN SALARY BETWEEN  8000 AND 10000 THEN
        INTO EMPLES_MANDOS  VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY,DEPARTMENT_ID)    
     WHEN SALARY < 8000 THEN
        INTO EMPLES_NORMALES VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY, MANAGER_ID)
    WHEN DEPARTMENT_ID=100 THEN
        INTO FINANCIERO VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY, MANAGER_ID)
SELECT * FROM EMPLOYEES;

SELECT COUNT(*) FROM EMPLES_JEFES;
SELECT COUNT(*) FROM EMPLES_MANDOS;
SELECT COUNT(*) FROM EMPLES_NORMALES;
SELECT COUNT(*) FROM FINANCIERO;

--insert first
TRUNCATE TABLE EMPLES_JEFES;
TRUNCATE TABLE EMPLES_MANDOS;
TRUNCATE TABLE EMPLES_NORMALES;
INSERT first
    WHEN SALARY > 10000 THEN
        INTO EMPLES_JEFES VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY)
     WHEN SALARY BETWEEN  8000 AND 10000 THEN
        INTO EMPLES_MANDOS  VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY,DEPARTMENT_ID)    
     WHEN SALARY < 8000 THEN
        INTO EMPLES_NORMALES VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY, MANAGER_ID)
    WHEN DEPARTMENT_ID=100 THEN
        INTO FINANCIERO VALUES(EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME, SALARY, MANAGER_ID)
SELECT * FROM EMPLOYEES;

SELECT COUNT(*) FROM EMPLES_JEFES;
SELECT COUNT(*) FROM EMPLES_MANDOS;
SELECT COUNT(*) FROM EMPLES_NORMALES;
SELECT COUNT(*) FROM FINANCIERO;

--CLAUSULA WITH

SELECT E.FIRST_NAME AS NOMBRE, DC.NUM_EMPLE AS NUMERO_EMPLEADOS,E.DEPARTMENT_ID
FROM EMPLOYEES E,
    (SELECT DEPARTMENT_ID, COUNT(*) AS NUM_EMPLE FROM EMPLOYEES GROUP BY DEPARTMENT_ID) DC
WHERE E.DEPARTMENT_ID = DC.DEPARTMENT_ID;
          

WITH VISTA_NUM_EMPLE AS
    ( SELECT DEPARTMENT_ID, COUNT(*) AS NUM_EMPLE FROM EMPLOYEES GROUP BY DEPARTMENT_ID)
SELECT E.FIRST_NAME AS NOMBRE, DC.NUM_EMPLE AS NUMERO_EMPLEADOS,E.DEPARTMENT_ID
FROM EMPLOYEES E, VISTA_NUM_EMPLE DC
WHERE E.DEPARTMENT_ID = DC.DEPARTMENT_ID;  

WITH SUM_SALARIO AS (SELECT DEPARTMENT_ID,SUM(SALARY) AS SALARIO_DEPARTAMENTO FROM EMPLOYEES GROUP BY DEPARTMENT_ID),
     NUM_EMPLE AS (SELECT DEPARTMENT_ID,COUNT(*) AS NUM_EMPLEADOS FROM EMPLOYEES GROUP BY DEPARTMENT_ID),
     NUM_EMPLE_TOTAL AS (SELECT COUNT(*) AS TOTAL_EMPLEADOS FROM EMPLOYEES)
SELECT DEPARTMENT_NAME, SALARIO_DEPARTAMENTO,NUM_EMPLEADOS,TOTAL_EMPLEADOS
FROM
DEPARTMENTS NATURAL JOIN SUM_SALARIO NATURAL JOIN NUM_EMPLE,NUM_EMPLE_TOTAL;


--ROLLUP
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY ROLLUP(DEPARTMENT_ID)
;

SELECT DEPARTMENT_ID,JOB_ID,SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID,JOB_ID)
order by department_id,job_id;

--CUBE
SELECT CITY,DEPARTMENT_NAME,COUNT(*)
FROM LOCATIONS NATURAL JOIN DEPARTMENTS  JOIN EMPLOYEES USING (DEPARTMENT_ID)
GROUP BY CITY,DEPARTMENT_NAME
ORDER BY CITY,DEPARTMENT_NAME;

SELECT CITY,DEPARTMENT_NAME,COUNT(*) AS EMPLEADOS
FROM LOCATIONS NATURAL JOIN DEPARTMENTS  JOIN EMPLOYEES USING (DEPARTMENT_ID)
GROUP BY CUBE(CITY,DEPARTMENT_NAME)
ORDER BY CITY,DEPARTMENT_NAME;

SELECT CITY,DEPARTMENT_NAME,JOB_ID,COUNT(*) AS EMPLEADOS
FROM LOCATIONS NATURAL JOIN DEPARTMENTS  JOIN EMPLOYEES USING (DEPARTMENT_ID)
GROUP BY CUBE(CITY,DEPARTMENT_NAME,JOB_ID)
ORDER BY CITY,DEPARTMENT_NAME,JOB_ID;

--GROUPING
SELECT DEPARTMENT_ID,JOB_ID,SUM(SALARY),GROUPING(DEPARTMENT_ID),GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID,JOB_ID)
order by department_id,job_id;

SELECT DECODE(GROUPING(JOB_ID),1,'TOTAL DEPARTAMENTO:'||DEPARTMENT_ID,DEPARTMENT_ID) AS "DEPARTAMENTO",
DECODE(GROUPING(DEPARTMENT_ID),1,'TOTAL:',job_id) AS "TRABAJO",
SUM(SALARY) AS "TOTAL SALARIO"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY ROLLUP(DEPARTMENT_ID,JOB_ID)
order by department_id,job_id;

--GROUPING SETS

SELECT DEPARTMENT_ID,SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY GROUPING SETS(DEPARTMENT_ID)
order by department_id;

SELECT DEPARTMENT_ID,JOB_ID,SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID,JOB_ID
order by department_id;


SELECT DEPARTMENT_ID,JOB_ID,SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY GROUPING SETS(DEPARTMENT_ID,JOB_ID)
order by department_id;

SELECT NULL,DEPARTMENT_ID,SUM(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID
UNION ALL
SELECT JOB_ID,NULL,SUM(SALARY) FROM EMPLOYEES GROUP BY JOB_ID;

SELECT DEPARTMENT_ID,JOB_ID,MANAGER_ID,SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY GROUPING SETS((DEPARTMENT_ID,JOB_ID),(DEPARTMENT_ID,MANAGER_ID))

--pivot y unpivot
DROP TABLE PIVOT;
CREATE TABLE PIVOT (
  CODIGO            NUMBER,
  CLIENTE   NUMBER,
  PRODUCTO  VARCHAR2(100),
  CANTIDAD      NUMBER
);

INSERT INTO PIVOT VALUES (1, 1, 'AGUACATES', 10);
INSERT INTO PIVOT VALUES (2, 1, 'BANANAS', 20);
INSERT INTO PIVOT VALUES (3, 1, 'MANZANA', 30);
INSERT INTO PIVOT VALUES (4, 2, 'AGUACATES', 40);
INSERT INTO PIVOT VALUES (5, 2, 'MANZANA', 50);
INSERT INTO PIVOT VALUES (6, 3, 'AGUACATES', 60);
INSERT INTO PIVOT VALUES (7, 3, 'BANANAS', 70);
INSERT INTO PIVOT VALUES (8, 3, 'MANZANA', 80);
INSERT INTO PIVOT VALUES (9, 3, 'NARANJA', 90);
INSERT INTO PIVOT VALUES (10, 4, 'AGUACATES', 100);
COMMIT;


SELECT * FROM PIVOT;

SELECT *
FROM   (SELECT PRODUCTO, CANTIDAD FROM   pivot)
PIVOT  ( count(CANTIDAD) FOR (PRODUCTO) IN ('AGUACATES','BANANAS','MANZANA','NARANJA'));

SELECT *
FROM   (SELECT PRODUCTO, CANTIDAD FROM   pivot)
PIVOT  (SUM(CANTIDAD) AS CANTIDAD FOR (PRODUCTO) IN ('AGUACATES','BANANAS','MANZANA','NARANJA'));


SELECT *
FROM   (SELECT CLIENTE,PRODUCTO, CANTIDAD FROM   pivot)
PIVOT  (SUM(CANTIDAD) AS CANTIDAD FOR (PRODUCTO) IN ('AGUACATES','BANANAS','MANZANA','NARANJA'));


-- y unpivot

DROP TABLE UN_PIVOT;

CREATE TABLE UN_PIVOT AS
SELECT *
FROM   (SELECT CLIENTE,PRODUCTO, CANTIDAD FROM   pivot)
PIVOT  (SUM(CANTIDAD) FOR (PRODUCTO) IN ('AGUACATES' AS "AGUACATES",'BANANAS' AS "BANANA",'MANZANA' AS "MANZANA",'NARANJA' AS "NARANJA"));

SELECT * FROM UN_PIVOT;

SELECT * FROM UN_PIVOT 
UNPIVOT (CANTIDAD FOR PRODUCTO IN ("AGUACATES","BANANA","MANZANA","NARANJA"))
ORDER BY CLIENTE,PRODUCTO;

