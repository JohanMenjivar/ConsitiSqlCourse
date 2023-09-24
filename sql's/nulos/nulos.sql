SELECT NVL(CITY, 'NO TIENE') AS "CIUDAD", NVL(STATE_PROVINCE,'NO TIENE') AS "ESTADO_PROVINCIA" FROM LOCATIONS;

SELECT SALARY AS "SALARIO",NVL(COMMISSION_PCT,'0') AS "COMISION" ,SALARY + (NVL(COMMISSION_PCT,0)/100*SALARY) AS "SALARIO + COMISION" FROM EMPLOYEES;

SELECT DEPARTMENT_NAME, NVL(MANAGER_ID,'-1') AS "MANAGER_ID" FROM DEPARTMENTS;

SELECT  CITY, STATE_PROVINCE, NULLIF(CITY, STATE_PROVINCE) AS RESULTADO  FROM LOCATIONS;