SET SERVEROUTPUT ON;

DECLARE
    c_Atleta1 INTEGER;
    c_Atleta2 INTEGER;
    c_Atleta3 INTEGER;
    c_Atleta4 INTEGER;

BEGIN
    /*PRUEBAS ATLETAS*/
        DBMS_OUTPUT.PUT_LINE('PRUEBAS ATLETAS: ');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------');
    PRUEBAS_ATLETAS.INICIALIZAR;
    PRUEBAS_ATLETAS.INSERTAR('Prueba 1 - insertar correctamente','Pedro', 'Alonso Pontiga', 19, 'M', 623844322, 'Avenida de la Paz',  'Lesionado', 'pedalopon@gmail.com', 'pedalolo3413', 1,true);
    c_Atleta1:=seq_Atletas.currval;
    PRUEBAS_ATLETAS.INSERTAR('Prueba 2 - insertar correctamente 2','Juan', 'Rodriguez Pontiga', 29, 'M', 623834322, 'Avenida Rodriguez',  'Lesionado', 'pe33256@gmail.com', 'pedalolo23421', 1,true);
    c_Atleta2:=seq_Atletas.currval;
    PRUEBAS_ATLETAS.INSERTAR('Prueba 3 - insertar nombre null',null, 'Alonso Pontiga', 19, 'M', 623844344, 'Avenida de la Paz',  'Lesionado', 'pedalopon12@gmail.com', 'pedalolo34133', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 4 - insertar apellido null','Paca', null, 19, 'M', 623844366, 'Avenida de la Paz',  'Lesionado', 'pedalopon232@gmail.com', 'pedalolo93838', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 5 - insertar edad null','Pedro', 'Alonso Pontiga', null, 'M', 623846789, 'Avenida de la Paz',  'Lesionado', 'pedalopon@gmail.com', 'pedalo321', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 6 - insertar genero null','Pedro', 'Alonso Pontiga', 19, null, 623846789, 'Avenida de la Paz',  'Lesionado', 'pedalopo897@gmail.com', 'pedalol98', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 7 - insertar genero check error','Pedro', 'Alonso Pontiga', 19, 'hola', 623846789, 'Avenida de la Paz',  'Lesionado', 'pedalopo897@gmail.com', 'pedalol98', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 8 - insertar telefono null','Pedro', 'Alonso Pontiga', 19, 'M', null, 'Avenida de la Paz',  'Lesionado', 'pedalop989@gmail.com', 'pedalo989', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 9 - insertar direccion null','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, null,  'Lesionado', 'pedalop999@gmail.com', 'pedalo999', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 10 - insertar estado fisico error check','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  'hola', 'pedalop444@gmail.com', 'pedalo999', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 11 - insertar estado fisico null','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  null, 'pedalop889@gmail.com', 'pedalo999', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 12 - insertar correo unico','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  'Lesionado', 'pedalopon@gmail.com', 'pedalo999', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 13 - insertar correo null','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  'Lesionado',null, 'pedalo999', 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 14 - insertar contrasenna null','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  'Lesionado', 'pedalop877@gmail.com', null, 1,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 15 - insertar activo error check','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  'Lesionado', 'pedalo653@gmail.com', 'pedalo999', 40,false);
    PRUEBAS_ATLETAS.INSERTAR('Prueba 16 - insertar activo null','Pedro', 'Alonso Pontiga', 19, 'M', 956846789, 'Avenida de la Paz',  'Lesionado', 'pedalo651@gmail.com', 'pedalo999', null,false);
    
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 17 - actualizar',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,true);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 18 - actualizar nombre null',c_Atleta2,null, 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 19 - actualizar apellido null',c_Atleta1,'Rafa', null, 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 20 - actualizar edad null',c_Atleta1,'Rafa', 'Lopez Pontiga', null, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 21 - actualizar genero check error',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'hola', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 1,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 22 - actualizar genero null',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, null, 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 23 - actualizar telefono null',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F',null, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 24 - actualizar direccion null',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123,null,  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 25 - actualizar estado fisico check error',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'adios', 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 26 - actualizar estado fisico null',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',null, 'rafapoon@gmail.com', 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 27 - actualizar correo null',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma',null, 'rafalolo', 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 28 - actualizar contrasenna null',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', null, 0,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 29 - actualizar activo check error',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', 30,false);
    PRUEBAS_ATLETAS.ACTUALIZAR('Prueba 30 - actualizar activo null ',c_Atleta1,'Rafa', 'Lopez Pontiga', 19, 'F', 849392123, 'Avenida de la Paz',  'Buena forma', 'rafapoon@gmail.com', 'rafalolo', null,false);    
    PRUEBAS_ATLETAS.ELIMINAR('Prueba 31 - borra ATLETA valido',c_Atleta1,true);
    PRUEBAS_ATLETAS.ELIMINAR('Prueba 32 - borra ATLETA valido',c_Atleta2,true);
    
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('PRUEBAS TRIGGERS:');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------');

    PRUEBAS_ATLETAS.INSERTAR('PTriggers 1 - atleta inactivo valido','Pepedro', 'Rodriguez Pontiga', 19, 'M', 623844322, 'Avenida de la Paz',  'Lesionado', 'p3dro@gmail.com', 'pedalolo', 0,true);
    c_Atleta3 := seq_Atletas.currval;
    pruebas_microciclos.inicializar;
    PRUEBAS_MICROCICLOS.INSERTAR('PTriggers 2 - microciclo atleta inactivo', 'Lesionado','Estirar y ejercitar zona lumbar', to_date('09/12/19', 'DD/MM/YY'),null, c_Atleta3,false);
    PRUEBAS_CONSULTAS.INICIALIZAR;
    PRUEBAS_ATLETAS.INSERTAR('PTriggers 3 - atleta valido','Lolo', 'Nunez Pontiga', 19, 'M', 623844322, 'Avenida de la Paz',  'Lesionado', 'p3FFdro@gmail.com', 'pedalolo', 1,true);
    c_Atleta4 := seq_Atletas.currval;
    PRUEBAS_CONSULTAS.INSERTAR('PTriggers 4 - consulta valida','Dietetica','Duda de dieta','he bebido mucha agua',c_Atleta4,true);
    PRUEBAS_CONSULTAS.INSERTAR('PTriggers 5 - consulta valida','Otro','Como te va la tarde?','Me intereso por mi entrenador',c_Atleta4,true);
    PRUEBAS_CONSULTAS.INSERTAR('PTriggers 6 - consulta no valida','Dietetica','Dolor fisico intenso','Dolor en la pierna tras correr',c_Atleta4,false);
    PRUEBAS_DIETAS.INICIALIZAR;
    PRUEBAS_DIETAS.INSERTAR('PTriggers 7 - Dieta atleta inactivo','Comer mucha pasta',to_date('09/12/19', 'DD/MM/YY'),to_date('09/12/20', 'DD/MM/YY'),c_Atleta3,false);
    
    PRUEBAS_MICROCICLOS.INSERTAR('PTriggers 8 - microciclo valido', 'Lesionado','Estirar y ejercitar zona lumbar', to_date('09/12/19', 'DD/MM/YY'),null, c_Atleta4,true);
    PRUEBAS_MICROCICLOS.INSERTAR('PTriggers 9 - microciclo misma fecha', 'Lesionado','Estirar y ejercitar zona lumbar', to_date('09/12/19', 'DD/MM/YY'),null, c_Atleta4,false);
    PRUEBAS_MICROCICLOS.INSERTAR('PTriggers 10 - microciclo distinto tipo', 'Buena forma','Estirar y ejercitar zona lumbar', to_date('09/12/19', 'DD/MM/YY'),null, c_Atleta4,false);

END;
/

exec mostrar_atletas(null,null,null, 1);
exec mostrar_atletas(null,null,null, 0);
exec comprobar_pagos;
exec mostrar_atletas(null,null,null, 1);
exec mostrar_atletas(null,null,null, 0);






