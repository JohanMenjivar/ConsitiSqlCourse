/**********Crear tablas y constraints************/

    COD_MATRICULA NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(20),
    APELLIDO1 VARCHAR2(20),
    APELLIDO2 VARCHAR2(20),
    EDAD NUMBER,
    FECHA_MATRICULA DATE
)

DESC ALUMNO;
CREATE TABLE CENTROS(
CODIGO_CENTRO NUMBER,
NOMBRE VARCHAR2(100),
PROVINCIA VARCHAR2(100) DEFAULT 'MADRID',
FECHA_ALTA DATE DEFAULT SYSDATE,
NUM_ALUMNOS NUMBER DEFAULT 0);

desc centros;

INSERT INTO CENTROS (CODIGO_CENTRO,NOMBRE) VALUES(1,'MATEMÁTICAS');
SELECT * FROM CENTROS;

CREATE TABLE CURSOS(
    COD_CURSO NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(100) NOT NULL UNIQUE,
    RESPONSABLE VARCHAR2(100)
)
DESC CURSOS;

INSERT INTO CURSOS (COD_CURSO, NOMBRE, RESPONSABLE)
VALUES (1, 'Curso de Matemáticas', 'Profesor A');

INSERT INTO CURSOS (COD_CURSO, NOMBRE)
VALUES (1, 'Curso de Historia');

/*********Otras constraints, crear tablas de otras, borrar tablas***********/

CREATE TABLE PAISES(
    COD_PAIS NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(100) NOT NULL CHECK(NOMBRE=UPPER(NOMBRE))
)


CREATE TABLE CIUDADES(
    COD_CIUDAD NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(100) NOT NULL CHECK(NOMBRE=UPPER(NOMBRE)),
    POBLACION NUMBER NOT NULL CHECK(POBLACION>0),
    COD_PAIS NUMBER,
    FOREIGN KEY (COD_PAIS) REFERENCES PAISES(COD_PAIS)
)

INSERT INTO PAISES VALUES('28','ESTADOS UNIDOS');

INSERT INTO PAISES VALUES('29','FRANcia');

INSERT INTO CIUDADES VALUES (1, 'NUEVA YORK', 4000000, 28);

INSERT INTO CIUDADES VALUES (2, 'ROMA', 3000000, 40);

INSERT INTO PAISES VALUES (40, 'ITALIA');

INSERT INTO CIUDADES VALUES (3, 'venecia', 3000000, 40);

INSERT INTO CIUDADES VALUES (3, 'VENECIA', 0, 40);

INSERT INTO CIUDADES VALUES (4, 'MILÁN', 3000000, 40);

INSERT INTO CIUDADES VALUES (5, 'FLORENCIA', 1500000, 40);
       
INSERT INTO CIUDADES VALUES (7, 'LOS ÁNGELES', 4000000, 28);

INSERT INTO CIUDADES VALUES (6, 'CHICAGO', 2700000, 28);
select * from ciudades

CREATE TABLE CIUDADES_PEQUE(
    COD_CIUDAD NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(100) NOT NULL CHECK(NOMBRE=UPPER(NOMBRE)),
    POBLACION NUMBER NOT NULL CHECK(POBLACION<2000000),
    COD_PAIS NUMBER,
    FOREIGN KEY (COD_PAIS) REFERENCES PAISES(COD_PAIS)
)

DESC CIUDADES_PEQUE;

ALTER TABLE CIUDADES_PEQUE
ADD BANDERA VARCHAR2(100);

INSERT INTO CIUDADES_PEQUE VALUES (9, 'MISSOURI', 1200000, 28, '../img/chicago.jpg');

SELECT * FROM CIUDADES_PEQUE;

ALTER TABLE CIUDADES_PEQUE
DROP COLUMN BANDERA;
DROP TABLE CIUDADES_PEQUE;

/*****************VISTAS*******************/

CREATE VIEW CIUDADES_GRANDES AS
SELECT * FROM CIUDADES WHERE POBLACION>3000000;
SELECT * FROM CIUDADES_GRANDES;

CREATE VIEW CIUDADES_USA AS
SELECT * FROM CIUDADES WHERE COD_PAIS=28;
SELECT * FROM CIUDADES_USA;

DROP VIEW CIUDADES_USA;
DROP VIEW CIUDADES_GRANDES;

CREATE INDEX INDEX_CIUDAD ON CIUDADES(NOMBRE);

CREATE SEQUENCE SEQ1 INCREMENT BY 5
MAXVALUE 1000000 MINVALUE 0 CACHE 20;

SELECT SEQ1.CURRVAL FROM DUAL ;

INSERT INTO PAISES VALUES(SEQ1.CURRVAL, 'UGANDA')

SELECT* FROM PAISES