CREATE TABLE "RANGO" 
   (	
    CODIGO NUMBER NOT NULL , 
	DATOS VARCHAR2(100)	
     ) 
  PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
     
     select * from rango;
     
     select * from user_part_tables;
     select * from user_tab_partitions where table_name='RANGO';
     
     
     insert into rango values(21,'aaa');
     select * from rango;
     select * from rango partition(p3);
      select * from rango partition(p1);
    insert into rango values(8,'fafsdaf');
     
       select * from rango partition(p1);
       select * from rango;
       
       select * from rango where codigo=21;
         
       select * from rango where codigo>21;
       
       select * from rango where datos ='aaaa';
       
       insert into rango values (40,'kkkkkk');
       
       alter table rango
       add partition p5 values less than (50);
       select * from user_tab_partitions where table_name='RANGO';
       insert into rango values (40,'kkkkkk');
       select * from rango partition(p5);
       
       
       alter table rango
       add partition p6 values less than (100);
       
       
       
       alter table rango
       add partition p7 values less than (MAXVALUE);
        select * from user_tab_partitions where table_name='RANGO';
              
        insert into rango values (40000000,'kkkkkk');
        
         
        select * from rango;
        update rango set codigo=22 WHERE codigo=21;
        
        update rango set codigo=7 WHERE codigo=22;

        alter table rango enable row movement;

        select * from rango partition(p1);
        
        select * from user_tab_partitions where table_name='RANGO';
        
        alter table rango merge partitions p3,p4 into partition p3_4;
        
        
/****particiones por lista de valores. rango-lista****/

CREATE TABLE RANGO_LISTA
   (	
    CODIGO NUMBER NOT NULL , 
	DATOS VARCHAR2(100)	,
    FECHA date,
    PAIS VARCHAR2(50)
     ) 
  PARTITION BY RANGE (FECHA)
     SUBPARTITION BY LIST(PAIS) 
    (
    PARTITION TRIMESTRE1 VALUES LESS THAN (TO_DATE('01-04-2023','dd-mm-yyyy'))
      ( 
      SUBPARTITION T1_P1 VALUES('ESPAÑA','FRANCIA','ALEMANIA'),
      SUBPARTITION T1_P2 VALUES('ARGENTINA','CHILE'),
      SUBPARTITION T1_P3 VALUES('USA','CANADA'),
      SUBPARTITION T1_P4 VALUES(DEFAULT)
      ),
    PARTITION TRIMESTRE2 VALUES LESS THAN (TO_DATE('01-07-2023','dd-mm-yyyy'))
      ( SUBPARTITION T2_P1 VALUES('ESPAÑA','FRANCIA','ALEMANIA'),
      SUBPARTITION T2_P2 VALUES('ARGENTINA','CHILE'),
      SUBPARTITION T2_P3 VALUES('USA','CANADA'),
      SUBPARTITION T2_P4 VALUES(DEFAULT)
    ),
    PARTITION TRIMESTRE3 VALUES LESS THAN (TO_DATE('01-10-2023','dd-mm-yyyy'))
        ( SUBPARTITION T3_P1 VALUES('ESPAÑA','FRANCIA','ALEMANIA'),
      SUBPARTITION T3_P2 VALUES('ARGENTINA','CHILE'),
      SUBPARTITION T3_P3 VALUES('USA','CANADA'),
      SUBPARTITION T3_P4 VALUES(DEFAULT)
    ),
    PARTITION TRIMESTRE4 VALUES LESS THAN (TO_DATE('01-01-2024','dd-mm-yyyy'))
        ( SUBPARTITION T4_P1 VALUES('ESPAÑA','FRANCIA','ALEMANIA'),
      SUBPARTITION T4_P2 VALUES('ARGENTINA','CHILE'),
      SUBPARTITION T4_P3 VALUES('USA','CANADA'),
      SUBPARTITION T4_P4 VALUES(DEFAULT)
    )
    );
    
           select * from user_tab_subpartitions where table_name='RANGO_LISTA';

INSERT INTO RANGO_LISTA VALUES(1,'AAAA',SYSDATE,'USA');
INSERT INTO RANGO_LISTA VALUES(2,'BBBB',SYSDATE,'CHILE');
SELECT * FROM RANGO_LISTA;
SELECT * FROM RANGO_LISTA PARTITION(TRIMESTRE2);
SELECT * FROM RANGO_LISTA SUBPARTITION(T3_P2);
SELECT * FROM RANGO_LISTA SUBPARTITION(T3_P3);
/************-hash-rango***********/
CREATE TABLE RANGO_SUB
   (	
    CODIGO NUMBER NOT NULL , 
	DATOS VARCHAR2(100)	,
    FECHA date,
    COD_CLIENTE NUMBER
     ) 
  PARTITION BY RANGE (FECHA)
     SUBPARTITION BY HASH(COD_CLIENTE) SUBPARTITIONS 3
  (
    PARTITION TIMESTRE1 VALUES LESS THAN (TO_DATE('01-04-2023','dd-mm-yyyy')),
    PARTITION TIMESTRE2 VALUES LESS THAN (TO_DATE('01-07-2023','dd-mm-yyyy')),
    PARTITION TIMESTRE3 VALUES LESS THAN (TO_DATE('01-10-2023','dd-mm-yyyy')),
    PARTITION TIMESTRE4 VALUES LESS THAN (TO_DATE('01-01-2024','dd-mm-yyyy'))
    );
select * from user_tab_partitions where table_name='RANGO_SUB';

select * from user_tab_subpartitions where table_name='RANGO_SUB';

-- Tabla normal e índice particionado

drop table t1;

create table t1
(codigo number,
datos varchar2(50));

create index g1_t1 on t1 (codigo) global partition by hash(codigo) partitions 4;

select * from user_ind_partitions where index_name='t2_i1';



-- Tabla particionada e índice normal

create table t2
(codigo number,
datos varchar2(50))
PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
     
     create index t2_i1 on t2(datos);
     
     
-- Tabla particionada e índice global particionado

drop table t3;
create table t3
(codigo number,
datos varchar2(50))
PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
        
     create index g1_t3 on t3 (datos) global partition by hash(datos) partitions 4;
     
-- indices particionados locales

drop table t4;
create table t4
(codigo number,
datos varchar2(50))
PARTITION BY RANGE (codigo)
  (
      PARTITION P1 VALUES LESS THAN (10),
      PARTITION P2 VALUES LESS THAN (20),
      PARTITION P3 VALUES LESS THAN (30),
      PARTITION P4 VALUES LESS THAN (40)
     );
     create index t4_i1 on t4(codigo) local ;
     select * from user_ind_partitions where index_name='T4_I1';
