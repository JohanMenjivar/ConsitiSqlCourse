/**************TO_CHAR******************/
SELECT * FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE,'MON')='MAY';

SELECT * FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE,'YYYY')=2007;

SELECT TO_CHAR(TO_DATE('11/09/00'),'DAY') FROM DUAL;

SELECT * FROM EMPLOYEES WHERE RTRIM(TO_CHAR(HIRE_DATE,'MONTH'))='JUNIO';

SELECT TO_CHAR(SALARY, '$999,999.99') AS "DOLARES", TO_CHAR(SALARY*0.79, 'L999,999.99') AS "EUROS" FROM EMPLOYEES;

/**************TO_NUMBER-TO_DATE****************/
SELECT TO_NUMBER('1210.73','9999.99') FROM DUAL;

SELECT TO_NUMBER('$127.2','$999.9') FROM DUAL;

SELECT TO_NUMBER(SUBSTR(PHONE_NUMBER,1,3))*2 FROM EMPLOYEES;

SELECT TO_DATE('10 DE FEBRERO DE 2018', 'DD "de" MONTH "de" YYYY') FROM DUAL;

SELECT TO_DATE('FACTURA: MARZO0806', '"FACTURA:" MONTHDDYY') FROM DUAL;
