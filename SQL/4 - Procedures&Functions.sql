/*Codigo de para la introduccion, el borrado y la actualizacion en cada tabla(Actualizacion y borrado solo atletas)*/
/*ATLETAS*/
CREATE OR REPLACE PROCEDURE nuevo_atleta 
(w_nombre IN ATLETAS.nombre%TYPE,
w_apellidos IN ATLETAS.apellidos%TYPE,
w_edad IN ATLETAS.edad%TYPE,
w_genero IN ATLETAS.genero%TYPE,
w_telefono IN ATLETAS.telefono%TYPE,
w_direccion IN ATLETAS.direccion%TYPE,
w_estadoFisico IN ATLETAS.estadoFisico%TYPE,
w_correo IN ATLETAS.correo%TYPE,
w_contrasenna IN ATLETAS.contrasenna%TYPE,
w_activo IN ATLETAS.activo%TYPE) IS
BEGIN
    INSERT INTO ATLETAS(nombre,apellidos,edad,genero,telefono,direccion,estadoFisico,correo,contrasenna,activo) 
        VALUES(w_nombre,w_apellidos,w_edad,w_genero,w_telefono,w_direccion,w_estadoFisico,w_correo,w_contrasenna,w_activo);
COMMIT WORK;
END nuevo_atleta;
/
/*ACTUALIZAR ATLETA*/
CREATE OR REPLACE PROCEDURE actualizar_atleta 
(w_idAtleta IN ATLETAS.idAtleta%TYPE,
w_nombre IN ATLETAS.nombre%TYPE,
w_apellidos IN ATLETAS.apellidos%TYPE,
w_edad IN ATLETAS.edad%TYPE,
w_genero IN ATLETAS.genero%TYPE,
w_telefono IN ATLETAS.telefono%TYPE,
w_direccion IN ATLETAS.direccion%TYPE,
w_estadoFisico IN ATLETAS.estadoFisico%TYPE,
w_correo IN ATLETAS.correo%TYPE,
w_contrasenna IN ATLETAS.contrasenna%TYPE,
w_activo IN ATLETAS.activo%TYPE) IS
BEGIN
    UPDATE  ATLETAS SET nombre=w_nombre,apellidos=w_apellidos,edad=w_edad,genero=w_genero,telefono=w_telefono,direccion=w_direccion,estadoFisico=w_estadoFisico
    ,correo=w_correo,contrasenna=w_contrasenna,activo=w_activo WHERE idAtleta=w_idAtleta;
COMMIT WORK;
END actualizar_atleta;
/

CREATE OR REPLACE PROCEDURE activar_atleta 
(w_idAtleta IN ATLETAS.idAtleta%TYPE) IS
BEGIN
    UPDATE  ATLETAS SET activo= 1 WHERE idAtleta=w_idAtleta;
COMMIT WORK;
END activar_atleta;
/

CREATE OR REPLACE PROCEDURE desactivar_atleta 
(w_idAtleta IN ATLETAS.idAtleta%TYPE) IS
BEGIN
    UPDATE  ATLETAS SET activo= 0 WHERE idAtleta=w_idAtleta;
COMMIT WORK;
END desactivar_atleta;
/

CREATE OR REPLACE PROCEDURE comprobar_pagos IS
CURSOR c IS
        SELECT * FROM ATLETAS;
fechaUltPago DATE;
        
BEGIN
    FOR fila IN c LOOP
        SELECT MAX(fecha) INTO fechaUltPago FROM PAGOS WHERE idAtleta = fila.idAtleta;
        
        IF(sysdate - fechaUltPago > 35 OR fechaUltPago IS null)
            THEN desactivar_atleta(fila.idAtleta);
        /*ELSIF(fila.activo = 0) 
            THEN activar_atleta(fila.idAtleta);*/
        END IF;
    END LOOP;

COMMIT WORK;
END comprobar_pagos;
/

/*ELIMINAR ATLETA*/
CREATE OR REPLACE PROCEDURE eliminar_atleta 
(w_idAtleta IN ATLETAS.idAtleta%TYPE) IS
BEGIN
    DELETE FROM ATLETAS WHERE idAtleta=w_idAtleta;
COMMIT WORK;
END eliminar_atleta;
/
/*MICROCICLO*/
CREATE OR REPLACE PROCEDURE introducir_microciclo
(w_tipo IN MICROCICLOS.tipo%TYPE,
w_descripcion IN MICROCICLOS.descripcion%TYPE,
w_fechaInicio IN MICROCICLOS.fechaInicio%TYPE,
w_recuperacion IN MICROCICLOS.recuperacion%TYPE,
w_idAtleta IN MICROCICLOS.idAtleta%TYPE) IS
BEGIN
    INSERT INTO MICROCICLOS(tipo,descripcion,fechaInicio,recuperacion,idAtleta) 
        VALUES(w_tipo,w_descripcion,w_fechaInicio,w_recuperacion,w_idAtleta);
COMMIT WORK;
END introducir_microciclo;
/

/*Feedback*/
CREATE OR REPLACE PROCEDURE introducir_feedback
(w_esfuerzo IN FEEDBACKS.esfuerzo%TYPE,
w_observaciones IN FEEDBACKS.observaciones%TYPE,
w_idMicrociclo IN FEEDBACKS.idMicrociclo%TYPE) IS
BEGIN
    INSERT INTO FEEDBACKS(esfuerzo,observaciones,idMicrociclo)
            VALUES(w_esfuerzo,w_observaciones,w_idMicrociclo);
COMMIT WORK;
END introducir_feedback;
/

/*MEDIA*/
CREATE OR REPLACE PROCEDURE introducir_media
(w_descripcion IN MEDIA.descripcion%TYPE,
w_rutaFichero IN MEDIA.rutaFichero%TYPE,
w_idFeedback IN MEDIA.idFeedback%TYPE) IS
BEGIN
    INSERT INTO MEDIA(descripcion, rutaFichero, idFeedback) VALUES(w_descripcion, w_rutaFichero, w_idFeedback);
COMMIT WORK;
END introducir_media;
/

/*EJERCICIOS*/
CREATE OR REPLACE PROCEDURE introducir_ejercicio
(w_titulo IN EJERCICIOS.titulo%TYPE,
w_descripcion IN EJERCICIOS.descripcion%TYPE,
w_tipo IN EJERCICIOS.tipo%TYPE) IS
BEGIN
    INSERT INTO EJERCICIOS(titulo, descripcion, tipo) VALUES(w_titulo, w_descripcion, w_tipo);
COMMIT WORK;
END introducir_ejercicio;
/

/*ESPECIFICACIONES*/
CREATE OR REPLACE PROCEDURE introducir_ej_a_microciclo
(w_repeticiones IN ESPECIFICACIONES.repeticiones%TYPE,
w_distancia IN ESPECIFICACIONES.distancia%TYPE,
w_idEjercicio IN ESPECIFICACIONES.idEjercicio%TYPE,
w_idMicrociclo IN ESPECIFICACIONES.idMicrociclo%TYPE) IS
BEGIN
    INSERT INTO ESPECIFICACIONES(repeticiones,distancia,idEjercicio,idMicrociclo)
            VALUES(w_repeticiones,w_distancia,w_idEjercicio,w_idMicrociclo);
COMMIT WORK;
END introducir_ej_a_microciclo;
/

/*COMPETICIONES*/
CREATE OR REPLACE PROCEDURE nueva_competicion
(w_lugar IN COMPETICIONES.lugar%TYPE,
w_nombre IN COMPETICIONES.nombre%TYPE,
w_fecha IN COMPETICIONES.fecha%TYPE,
w_tipo IN COMPETICIONES.tipo%TYPE,
w_alcance IN COMPETICIONES.alcance%TYPE) IS
BEGIN
    INSERT INTO COMPETICIONES(lugar,nombre,fecha,tipo,alcance) 
        VALUES(w_lugar,w_nombre,w_fecha,w_tipo,w_alcance);
COMMIT WORK;
END nueva_competicion;
/

/*PAGOS*/
CREATE OR REPLACE PROCEDURE introducir_pago
(w_Fecha IN PAGOS.fecha%TYPE,
w_idAtleta IN PAGOS.idAtleta%TYPE)IS
BEGIN
    INSERT INTO PAGOS(Fecha,idAtleta) 
        VALUES(w_Fecha,w_idAtleta);
COMMIT WORK;
END introducir_pago;
/

/*REUNIONES*/
CREATE OR REPLACE PROCEDURE nueva_reunion
(w_Fecha IN REUNIONES.fecha%TYPE,
w_Lugar IN REUNIONES.lugar%TYPE,
w_Duracion IN REUNIONES.duracion%TYPE)IS
BEGIN
    INSERT INTO REUNIONES(Fecha,Lugar,Duracion) 
                VALUES(w_Fecha,w_Lugar,w_duracion);
COMMIT WORK;
END nueva_reunion;
/

/*PRUEBAS*/
CREATE OR REPLACE PROCEDURE nueva_prueba
(w_Tipo IN pruebas.Tipo%TYPE,
w_Fecha IN pruebas.Fecha%TYPE,
w_idAtleta IN pruebas.idAtleta%TYPE) IS
BEGIN
    INSERT INTO PRUEBAS(Tipo,Fecha,idAtleta) VALUES(w_Tipo,w_Fecha,w_idAtleta);
COMMIT WORK;
END nueva_prueba;
/

/*DOCUMENTOS*/
CREATE OR REPLACE PROCEDURE introducir_documento
(w_descripcion IN documentos.descripcion%TYPE,
w_rutaFichero IN documentos.rutaFichero%TYPE,
w_idPago IN documentos.idPago%TYPE,
w_idPrueba IN documentos.idPrueba%TYPE) IS
BEGIN
    INSERT INTO documentos(descripcion, rutaFichero, idPago, idPrueba) VALUES(w_descripcion, w_rutaFichero, w_idPago, w_idPrueba);
COMMIT WORK;
END introducir_documento;
/

/*DIETAS*/
CREATE OR REPLACE PROCEDURE nueva_dieta
(w_Descripcion IN DIETAS.Descripcion%TYPE,
 w_FechaFin IN DIETAS.FechaFin%TYPE,
 w_FechaInicio IN DIETAS.FechaInicio%TYPE,
 w_idAtleta IN DIETAS.idAtleta%TYPE) IS 
 BEGIN 
        INSERT INTO DIETAS(Descripcion,FechaFin,FechaInicio,idAtleta) 
                VALUES(w_Descripcion,w_FechaFin,w_FechaInicio,w_idAtleta);
                COMMIT WORK;
END nueva_dieta;
/


/*CONSULTAS*/
CREATE OR REPLACE PROCEDURE nueva_consulta
(w_Tipo IN CONSULTAS.Tipo%TYPE,
w_Tema IN CONSULTAS.Tema%TYPE,
w_Descripcion IN CONSULTAS.descripcion%TYPE,
w_idAtleta IN CONSULTAS.idAtleta%TYPE)IS
BEGIN
    INSERT INTO CONSULTAS(Tipo,Tema,Descripcion,Respuesta,idAtleta) 
                VALUES(w_Tipo, w_Tema, w_Descripcion,'', w_idAtleta);
COMMIT WORK;
END nueva_consulta;
/
CREATE OR REPLACE PROCEDURE respuesta_consulta 
(
w_Respuesta IN CONSULTAS.Respuesta%TYPE,
w_idConsulta IN CONSULTAS.idConsulta%TYPE)IS
BEGIN
    UPDATE  CONSULTAS SET Respuesta=w_Respuesta WHERE idConsulta=w_idConsulta;
COMMIT WORK;
END respuesta_consulta;
/

/*ASISTENCIAS*/
CREATE OR REPLACE PROCEDURE nueva_asistencia
(w_idAtleta IN asistencias.idAtleta%TYPE,
w_idReunion IN asistencias.idReunion%TYPE) IS
BEGIN
    INSERT INTO ASISTENCIAS(idAtleta,idReunion) VALUES(w_idAtleta,w_idReunion);
COMMIT WORK;
END nueva_asistencia;
/

/*RESULTADOS*/
CREATE OR REPLACE PROCEDURE nuevo_resultado
(w_idAtleta IN RESULTADOS.idAtleta%TYPE,
w_idCompeticion IN RESULTADOS.idCompeticion%TYPE,
w_prueba IN RESULTADOS.prueba%TYPE,
w_marca IN RESULTADOS.marca%TYPE,
w_posicion IN RESULTADOS.posicion%TYPE) IS 
BEGIN 
    INSERT INTO RESULTADOS(idAtleta,idCompeticion,prueba,marca,posicion)
        VALUES(w_idAtleta,w_idCompeticion,w_prueba,w_marca,w_posicion);
COMMIT WORK;
END nuevo_Resultado;
/

/*FUNCIONES*/
/*Esta funcion devuelve el numero de dias que tiene un determinado microciclo*/
CREATE OR REPLACE FUNCTION duracion_microciclo
(w_idMicrociclo IN MICROCICLOS.idMicrociclo%type) 
RETURN NUMBER
IS w_dias NUMBER;
w_inicio MICROCICLOS.fechaInicio%type;
w_fin MICROCICLOS.fechaFin%type;
BEGIN
SELECT  fechaFin-fechaInicio INTO w_dias FROM MICROCICLOS WHERE idMicrociclo=w_idMicrociclo;
return w_dias;
END duracion_microciclo;
/
/*Esta funcion anade 7 dias a una fecha que se introduzca*/
CREATE OR REPLACE FUNCTION dias_mas
(w_fecha DATE)
RETURN DATE
IS w_dias7 DATE;
BEGIN 
w_dias7:=w_fecha+7;
return w_dias7;
END dias_mas;
/
/*Esta funcion devuelve el numero de dias para que acabe un determinado microciclo*/
CREATE OR REPLACE FUNCTION dias_restantes_fin
(fechaFin date) 
RETURN NUMBER
IS 
w_dias NUMBER;
BEGIN
SELECT fechaFin - sysdate INTO w_dias FROM DUAL;
IF(w_dias < 0) THEN
    w_dias := 0;
END IF;
return w_dias;
END dias_restantes_fin;
/


