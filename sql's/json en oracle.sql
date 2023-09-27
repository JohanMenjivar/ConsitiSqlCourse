CREATE TABLE productos1 (
  codigo INT,
  nombre VARCHAR2(200),
  datos json
);



insert into productos1
values ( 1,'ejemplo1',
'
  {
    "pais": "Argentina",
    "ciudad": "Buenos aires",
    "poblacion": 1000000
  }
');

select * from productos1;

SELECT prod1.datos.pais from productos1 prod1;

select datos from productos1;

select prod1.datos.pais from productos1 prod1;


insert into productos1
values ( 2,'ejemplo1',
'
  {
    "pais": "Argentina",
    "ciudad": "Buenos aires",
    "poblacion": 1000000,
    "direccion":{
             "calle": "xcxxxxx",
             "piso": 5,
             "puerta": "c"
             }
  }
');

select prod1.datos.direccion from productos1 prod1;

select prod1.datos.direccion.puerta from productos1 prod1;


insert into productos1
values ( 3,'ejemplo3',
'
  {
    "pais": "Francia",
    "ciudad": "Paris",
    "poblacion": 1500000,
    "direccion":{
             "calle": "xcxxxxx",
             "piso": 5,
             "puerta": "c"
             },
    "telefonos": [
        "111-111111",
        "222-222222"
    ]
  }
');

select datos from productos1;

select prod1.datos.telefonos from productos1 prod1;
select prod1.datos.telefonos[0] from productos1 prod1;

--IS JSON
CREATE TABLE ejemplo (
  codigo INT,
  fichero CLOB
);

insert into ejemplo values(1,'{"col1":"prueba"}');
insert into ejemplo values(2,'Esto es una prueba');
insert into ejemplo values(3,'<doc> <col1>prueba</col1></doc>');

select * from ejemplo where fichero is json;

select * from ejemplo where fichero is not json;

--JSON EXISTS
drop table productos1;

CREATE TABLE productos1 (
  codigo INT,
  nombre VARCHAR2(200),
  datos json
);

insert into productos1
values ( 1,'ejemplo1',
'
  {
    "pais": "Argentina",
    "ciudad": "Buenos aires",
    "poblacion": 1000000
  }
');



insert into productos1
values ( 2,'ejemplo1',
'
  {
    "pais": "Argentina",
    "ciudad": "Buenos aires",
    "poblacion": 1000000,
    "direccion":{
             "calle": "xcxxxxx",
             "piso": 5,
             "puerta": "c"
             }
  }
');


insert into productos1
values ( 3,'ejemplo3',
'
  {
    "pais": "Francia",
    "ciudad": "Paris",
    "poblacion": 1500000,
    "direccion":{
             "calle": "xcxxxxx",
             "piso": 5,
             "puerta": "c"
             },
    "telefonos": [
        "111-111111",
        "222-222222"
    ]
  }
');


insert into productos1
values ( 4,'ejemplo4',
'
  {
    "pais": "Italia",
    "ciudad": "Roma",
    "poblacion": 1400000,
    "direccion":{
             "calle": "xcxxxxx",
             "piso": 4,
             "puerta": ""
             },
    "telefonos": [
        "111-111111AA",
        "222-222222BB"
    ]
  }
');


insert into productos1
values ( 5,'ejemplo5',
'
  {
    "pais": "Inglaterra",
    "ciudad": "Londres",
    "poblacion": 10009000
  }
');

select * from productos1;
--JSON EXISTS
select prod1.datos from productos1 prod1 where json_exists(prod1.datos,'$.ciudad');
select prod1.datos from productos1 prod1 where json_exists(prod1.datos,'$.direccion.calle');
select prod1.datos from productos1 prod1 where json_exists(prod1.datos,'$.telefonos[0]');
select prod1.datos from productos1 prod1 where json_exists(prod1.datos,'$.telefonos[1]');



--obtener valores simples
select json_value(prod1.datos,'$.pais') from productos1 prod1;
select json_value(prod1.datos,'$.pais' returning varchar(100)) from productos1 prod1;
-- Si no son escalare no funciona
select json_value(prod1.datos,'$.direccion') from productos1 prod1;
select json_value(prod1.datos,'$.telefonos') from productos1 prod1;
select json_value(prod1.datos,'$.telefonos[0]') from productos1 prod1;

select json_query(prod1.datos,'$.pais') from productos1 prod1;
select json_query(prod1.datos,'$.direccion') from productos1 prod1;
select json_query(prod1.datos,'$.direccion.calle') from productos1 prod1;
select json_query(prod1.datos,'$.telefonos') from productos1 prod1;
select json_query(prod1.datos,'$.telefonos[0]') from productos1 prod1;


select prod1.datos.pais from productos1 prod1;


--JSON TABLE
 select pais,ciudad
       from productos1 prod1,json_table(prod1.datos,'$' COLUMNS(pais PATH '$.pais', ciudad path '$.ciudad'));
   
   select pais,direccion
       from productos1 prod1,json_table(prod1.datos,'$' COLUMNS(pais PATH '$.pais', direccion path '$.direccion.calle'));
       
--JSON MERGEPATCH
   select datos from productos1;
   
   -- Modificar uno existente
   update productos1 set datos='
  {
    "pais": "Argentina",
    "ciudad": "Buenos aires",
    "poblacion": 2000000
  }' 
  where codigo=1;
  
  
  -- Añadir un elemento
     update productos1 set datos='
  {
    "pais": "Argentina",
    "ciudad": "Buenos aires",
    "poblacion": 2100000,
    "estado": true
  }' 
  where codigo=1;
  
  -- JSON_MERGEPATCH
      update productos1 set datos=JSON_MERGEPATCH(
      datos,
      '{
            "estado": false
      }' 
      )
  where codigo=1;
  
  
     update productos1 set datos=JSON_MERGEPATCH(
      datos,
      '{
            "estado": true,
            "c1": 10
      }' 
      )
  where codigo=1;