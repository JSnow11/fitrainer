/*Codigo del paquete de pruebas para comprobar tanto la inicializacion,introduccion,actualizacion y borrado de cada tabla*/
CREATE OR REPLACE FUNCTION ASSERT_EQUALS(salida BOOLEAN,salida_esperada BOOLEAN) RETURN VARCHAR2 AS
BEGIN 
    IF(salida=salida_esperada)THEN
        RETURN 'EXITO';
    ELSE
        RETURN 'FALLO';
    END IF;
END ASSERT_EQUALS;
/
CREATE OR REPLACE PACKAGE PRUEBAS_ATLETAS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_nombre IN ATLETAS.nombre%TYPE, w_apellidos IN ATLETAS.apellidos%TYPE ,w_edad IN ATLETAS.edad%TYPE,
w_genero IN ATLETAS.genero%TYPE, w_telefono IN ATLETAS.telefono%TYPE, w_direccion IN ATLETAS.direccion%TYPE, w_estadoFisico IN ATLETAS.estadoFisico%TYPE,
w_correo IN ATLETAS.correo%TYPE,w_contrasenna IN ATLETAS.contrasenna%TYPE, w_activo IN ATLETAS.activo%TYPE, salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2, w_idAtleta IN ATLETAS.idAtleta%TYPE, w_nombre IN ATLETAS.nombre%TYPE,w_apellidos IN ATLETAS.apellidos%TYPE ,w_edad IN ATLETAS.edad%TYPE,
w_genero IN ATLETAS.genero%TYPE, w_telefono IN ATLETAS.telefono%TYPE, w_direccion IN ATLETAS.direccion%TYPE, w_estadoFisico IN ATLETAS.estadoFisico%TYPE,w_correo IN ATLETAS.correo%TYPE,
w_contrasenna IN ATLETAS.contrasenna%TYPE, w_activo IN ATLETAS.activo%TYPE, salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idAtleta IN ATLETAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_ATLETAS;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_ATLETAS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM ATLETAS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_nombre IN ATLETAS.nombre%TYPE,w_apellidos IN ATLETAS.apellidos%TYPE ,w_edad IN ATLETAS.edad%TYPE,
w_genero IN ATLETAS.genero%TYPE, w_telefono IN ATLETAS.telefono%TYPE, w_direccion IN ATLETAS.direccion%TYPE, w_estadoFisico IN ATLETAS.estadoFisico%TYPE,
w_correo IN ATLETAS.correo%TYPE,w_contrasenna IN ATLETAS.contrasenna%TYPE, w_activo IN ATLETAS.activo%TYPE, salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
ATLETA_TIPO ATLETAS%ROWTYPE;
w_idAtleta INTEGER;
BEGIN 
nuevo_atleta(w_nombre,w_apellidos,w_edad,
        w_genero,w_telefono,w_direccion,w_estadoFisico,w_correo,w_contrasenna,
        w_activo);
w_idAtleta := seq_Atletas.currval;
SELECT * INTO ATLETA_TIPO FROM ATLETAS WHERE ATLETAS.idAtleta=w_idAtleta;
IF(ATLETA_TIPO.idAtleta<>w_idAtleta)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2, w_idAtleta IN ATLETAS.idAtleta%TYPE, w_nombre IN ATLETAS.nombre%TYPE,w_apellidos IN ATLETAS.apellidos%TYPE ,w_edad IN ATLETAS.edad%TYPE,
    w_genero IN ATLETAS.genero%TYPE, w_telefono IN ATLETAS.telefono%TYPE, w_direccion IN ATLETAS.direccion%TYPE, w_estadoFisico IN ATLETAS.estadoFisico%TYPE,w_correo IN ATLETAS.correo%TYPE,
    w_contrasenna IN ATLETAS.contrasenna%TYPE, w_activo IN ATLETAS.activo%TYPE, salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
ATLETA_TIPO ATLETAS%ROWTYPE;
BEGIN 
    actualizar_atleta(w_idAtleta,w_nombre,w_apellidos,w_edad,
        w_genero,w_telefono,w_direccion,w_estadoFisico,w_correo,w_contrasenna,
        w_activo);
    SELECT * INTO ATLETA_TIPO FROM ATLETAS WHERE idatleta=w_idatleta;
    IF(ATLETA_TIPO.nombre<>w_nombre 
    OR ATLETA_TIPO.apellidos<>w_apellidos
    OR ATLETA_TIPO.edad<>w_edad
    OR ATLETA_TIPO.genero<>w_genero
    OR ATLETA_TIPO.telefono<>w_telefono
    OR ATLETA_TIPO.direccion<>w_direccion
    OR ATLETA_TIPO.estadoFisico<> w_estadoFisico
    OR ATLETA_TIPO.correo<> w_correo
    OR ATLETA_TIPO.contrasenna<>w_contrasenna
    OR ATLETA_TIPO.activo<>w_activo) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idAtleta IN ATLETAS.idAtleta%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_ATLETAS INTEGER;
    BEGIN
        eliminar_atleta(w_idAtleta);
        SELECT COUNT(*) INTO N_ATLETAS FROM ATLETAS WHERE idAtleta=w_idAtleta;
        IF (N_ATLETAS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_ATLETAS;

/

CREATE OR REPLACE PACKAGE PRUEBAS_MICROCICLOS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_tipo IN MICROCICLOS.tipo%type,w_descripcion IN MICROCICLOS.descripcion%type,w_fechaInicio IN MICROCICLOS.fechaInicio%type,w_recuperacion IN MICROCICLOS.recuperacion%type ,w_idAtleta IN MICROCICLOS.idAtleta%type,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idMicrociclo IN MICROCICLOS.idmicrociclo%TYPE,w_tipo IN MICROCICLOS.tipo%type,w_descripcion IN MICROCICLOS.descripcion%type,w_fechaInicio IN MICROCICLOS.fechaInicio%type,w_recuperacion IN MICROCICLOS.recuperacion%type ,w_idAtleta IN MICROCICLOS.idAtleta%type,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idMicrociclo IN MICROCICLOS.idmicrociclo%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_MICROCICLOS;

/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_MICROCICLOS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM MICROCICLOS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_tipo IN MICROCICLOS.tipo%type,w_descripcion IN MICROCICLOS.descripcion%type,w_fechaInicio IN MICROCICLOS.fechaInicio%type,w_recuperacion IN MICROCICLOS.recuperacion%type ,w_idAtleta IN MICROCICLOS.idAtleta%type,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
MICROCICLO_TIPO MICROCICLOS%ROWTYPE;
w_idMicrociclo Integer;
BEGIN 
introducir_microciclo(w_tipo,w_descripcion,w_fechaInicio,w_recuperacion,w_idAtleta);
w_idMicrociclo := seq_Microciclo.currval;
SELECT * INTO MICROCICLO_TIPO FROM MICROCICLOS WHERE MICROCICLOS.idMicrociclo=w_idMicrociclo;
IF(MICROCICLO_TIPO.idMicrociclo<>w_idMicrociclo)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idMicrociclo IN MICROCICLOS.idmicrociclo%TYPE,w_tipo IN MICROCICLOS.tipo%type,w_descripcion IN MICROCICLOS.descripcion%type,w_fechaInicio IN MICROCICLOS.fechaInicio%type,w_recuperacion IN MICROCICLOS.recuperacion%type ,w_idAtleta IN MICROCICLOS.idAtleta%type,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
MICROCICLO_TIPO MICROCICLOS%ROWTYPE;
BEGIN 
    UPDATE MICROCICLOS SET tipo=w_tipo,descripcion=w_descripcion,fechaInicio=w_fechaInicio,recuperacion=w_recuperacion,idAtleta=w_idAtleta WHERE idMicrociclo=w_idMicrociclo;
    SELECT * INTO MICROCICLO_TIPO FROM MICROCICLOS WHERE MICROCICLOS.idMicrociclo=w_idMicrociclo;
    IF(MICROCICLO_TIPO.tipo<>w_tipo 
    OR MICROCICLO_TIPO.descripcion<>w_descripcion
    OR MICROCICLO_TIPO.fechaInicio<>w_fechaInicio
    OR MICROCICLO_TIPO.recuperacion<>w_recuperacion
    OR MICROCICLO_TIPO.idAtleta<>w_idAtleta) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idMicrociclo IN MICROCICLOS.idmicrociclo%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_MICROCICLOS INTEGER;
    BEGIN
        DELETE FROM MICROCICLOS WHERE idMicrociclo=w_idMicrociclo;
        SELECT COUNT(*) INTO N_MICROCICLOS FROM MICROCICLOS WHERE idMicrociclo=w_idMicrociclo;
        IF (N_MICROCICLOS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_MICROCICLOS;
/


CREATE OR REPLACE PACKAGE PRUEBAS_FEEDBACKS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_esfuerzo IN FEEDBACKS.esfuerzo%TYPE,w_observaciones IN FEEDBACKS.observaciones%TYPE,w_idMicrociclo IN FEEDBACKS.idMicrociclo%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idFeedback IN FEEDBACKS.idFeedback%TYPE ,w_esfuerzo IN FEEDBACKS.esfuerzo%TYPE,w_observaciones IN FEEDBACKS.observaciones%TYPE,w_idMicrociclo IN FEEDBACKS.idMicrociclo%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idFeedback IN FEEDBACKS.idFeedback%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_FEEDBACKS;

/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_FEEDBACKS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM FEEDBACKS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_esfuerzo IN FEEDBACKS.esfuerzo%TYPE,w_observaciones IN FEEDBACKS.observaciones%TYPE,w_idMicrociclo IN FEEDBACKS.idMicrociclo%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
FEEDBACK_TIPO FEEDBACKS%ROWTYPE;
w_idFeedback Integer;
BEGIN 
introducir_feedback(w_esfuerzo,w_observaciones,w_idMicrociclo);
w_idFeedback := seq_Feedback.currval;
SELECT * INTO FEEDBACK_TIPO FROM FEEDBACKS WHERE FEEDBACKS.idFeedback=w_idFeedback;
IF(FEEDBACK_TIPO.idFeedback<>w_idFeedback)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idFeedback IN FEEDBACKS.idFeedback%TYPE ,w_esfuerzo IN FEEDBACKS.esfuerzo%TYPE,w_observaciones IN FEEDBACKS.observaciones%TYPE,w_idMicrociclo IN FEEDBACKS.idMicrociclo%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
FEEDBACK_TIPO FEEDBACKS%ROWTYPE;
BEGIN 
    UPDATE FEEDBACKS SET esfuerzo=w_esfuerzo,observaciones=w_observaciones,idMicrociclo=w_idMicrociclo WHERE idFeedback=w_idFeedback;
    SELECT * INTO FEEDBACK_TIPO FROM FEEDBACKS WHERE FEEDBACKS.idMicrociclo=w_idMicrociclo;
    IF(FEEDBACK_TIPO.esfuerzo<>w_esfuerzo
    OR FEEDBACK_TIPO.observaciones<>w_observaciones
    OR FEEDBACK_TIPO.idMicrociclo<>w_idMicrociclo) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idFeedback IN FEEDBACKS.idFeedback%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_FEEDBACKS INTEGER;
    BEGIN
        DELETE FROM FEEDBACKS WHERE idFeedback=w_idFeedback;
        SELECT COUNT(*) INTO N_FEEDBACKS FROM FEEDBACKS WHERE idFeedback=w_idFeedback;
        IF (N_FEEDBACKS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_FEEDBACKS;
/


CREATE OR REPLACE PACKAGE PRUEBAS_MEDIA AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_descripcion IN MEDIA.descripcion%TYPE,w_rutaFichero IN MEDIA.rutaFichero%TYPE,w_idFeedback IN MEDIA.idFeedback%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idMedia IN MEDIA.idMedia%TYPE,w_descripcion IN MEDIA.descripcion%TYPE,w_rutaFichero IN MEDIA.rutaFichero%TYPE,w_idFeedback IN MEDIA.idFeedback%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idMedia IN MEDIA.idMedia%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_MEDIA;
/

CREATE OR REPLACE PACKAGE BODY PRUEBAS_MEDIA AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM MEDIA ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_descripcion IN MEDIA.descripcion%TYPE,w_rutaFichero IN MEDIA.rutaFichero%TYPE,w_idFeedback IN MEDIA.idFeedback%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
MEDIA_TIPO MEDIA%ROWTYPE;
w_idMedia Integer;
BEGIN 
introducir_media(w_descripcion, w_rutaFichero, w_idFeedback);
w_idMedia := seq_Media.currval;
SELECT * INTO MEDIA_TIPO FROM MEDIA WHERE MEDIA.idMedia=w_idMedia;
IF(MEDIA_TIPO.idMedia<>w_idMedia)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idMedia IN MEDIA.idMedia%TYPE,w_descripcion IN MEDIA.descripcion%TYPE,w_rutaFichero IN MEDIA.rutaFichero%TYPE,w_idFeedback IN MEDIA.idFeedback%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
MEDIA_TIPO MEDIA%ROWTYPE;
BEGIN 
    UPDATE MEDIA SET descripcion=w_descripcion,rutaFichero=w_rutaFichero,idFeedback=w_idFeedback WHERE idMedia=w_idMedia;
    SELECT * INTO MEDIA_TIPO FROM MEDIA WHERE MEDIA.idMedia=w_idMedia;
    IF(MEDIA_TIPO.descripcion<>w_descripcion
    OR MEDIA_TIPO.rutaFichero<>w_rutaFichero
    OR MEDIA_TIPO.idFeedback<>w_idFeedback) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idMedia IN MEDIA.idMedia%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_MEDIA INTEGER;
    BEGIN
        DELETE FROM MEDIA WHERE idMedia=w_idMedia;
        SELECT COUNT(*) INTO N_MEDIA FROM MEDIA WHERE idMedia=w_idMedia;
        IF (N_MEDIA<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_MEDIA;
/
CREATE OR REPLACE PACKAGE PRUEBAS_EJERCICIOS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_titulo IN EJERCICIOS.titulo%TYPE,w_descripcion IN EJERCICIOS.descripcion%TYPE ,w_tipo IN EJERCICIOS.tipo%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idEjercicio IN EJERCICIOS.idEjercicio%TYPE,w_titulo IN EJERCICIOS.titulo%TYPE,w_descripcion IN EJERCICIOS.descripcion%TYPE ,w_tipo IN EJERCICIOS.tipo%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idEjercicio IN EJERCICIOS.idEjercicio%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_EJERCICIOS;
/

CREATE OR REPLACE PACKAGE BODY PRUEBAS_EJERCICIOS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM EJERCICIOS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_titulo IN EJERCICIOS.titulo%TYPE,w_descripcion IN EJERCICIOS.descripcion%TYPE ,w_tipo IN EJERCICIOS.tipo%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
EJERCICIOS_TIPO EJERCICIOS%ROWTYPE;
w_idEjercicio Integer;
BEGIN 
introducir_ejercicio(w_titulo,w_descripcion, w_tipo);
w_idEjercicio := seq_Ejercicio.currval;
SELECT * INTO EJERCICIOS_TIPO FROM EJERCICIOS WHERE EJERCICIOS.idEjercicio=w_idEjercicio;
IF(EJERCICIOS_TIPO.idEjercicio<>w_idEjercicio)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idEjercicio IN EJERCICIOS.idEjercicio%TYPE,w_titulo IN EJERCICIOS.titulo%TYPE,w_descripcion IN EJERCICIOS.descripcion%TYPE ,w_tipo IN EJERCICIOS.tipo%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
EJERCICIOS_TIPO EJERCICIOS%ROWTYPE;
BEGIN 
    UPDATE EJERCICIOS SET titulo=w_titulo,descripcion=w_descripcion, tipo=w_tipo WHERE idEjercicio=w_idEjercicio;
    SELECT * INTO EJERCICIOS_TIPO FROM EJERCICIOS WHERE EJERCICIOS.idEjercicio=w_idEjercicio;
    IF(EJERCICIOS_TIPO.titulo<>w_titulo
    OR EJERCICIOS_TIPO.descripcion<>w_descripcion
    OR EJERCICIOS_TIPO.tipo<>w_tipo) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idEjercicio IN EJERCICIOS.idEjercicio%TYPE,salidaEsperada BOOLEAN)AS
    salida BOOLEAN:= TRUE;
    N_EJERCICIOS INTEGER;
    BEGIN
        DELETE FROM EJERCICIOS WHERE idEjercicio=w_idEjercicio;
        SELECT COUNT(*) INTO N_EJERCICIOS FROM EJERCICIOS WHERE idEjercicio=w_idEjercicio;
        IF (N_EJERCICIOS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
    
END PRUEBAS_EJERCICIOS;
/


CREATE OR REPLACE PACKAGE PRUEBAS_ESPECIFICACIONES AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_repeticiones IN ESPECIFICACIONES.repeticiones%TYPE,
w_distancia IN ESPECIFICACIONES.distancia%TYPE,w_idEjercicio IN ESPECIFICACIONES.idEjercicio%TYPE,
w_idMicrociclo IN ESPECIFICACIONES.idMicrociclo%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idEspecificacion IN ESPECIFICACIONES.idEspecificacion%TYPE,w_repeticiones IN ESPECIFICACIONES.repeticiones%TYPE,
w_distancia IN ESPECIFICACIONES.distancia%TYPE,w_idEjercicio IN ESPECIFICACIONES.idEjercicio%TYPE,
w_idMicrociclo IN ESPECIFICACIONES.idMicrociclo%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idEspecificacion IN ESPECIFICACIONES.idEspecificacion%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_ESPECIFICACIONES;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_ESPECIFICACIONES AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM ESPECIFICACIONES ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_repeticiones IN ESPECIFICACIONES.repeticiones%TYPE,
w_distancia IN ESPECIFICACIONES.distancia%TYPE,w_idEjercicio IN ESPECIFICACIONES.idEjercicio%TYPE,
w_idMicrociclo IN ESPECIFICACIONES.idMicrociclo%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
ESPECIFICACIONES_TIPO ESPECIFICACIONES%ROWTYPE;
w_idEspecificacion INTEGER;
BEGIN 
introducir_ej_a_microciclo(w_repeticiones,w_distancia,w_idEjercicio,w_idMicrociclo);
w_idEspecificacion := seq_Especificacion.currval;
SELECT * INTO ESPECIFICACIONES_TIPO FROM ESPECIFICACIONES WHERE ESPECIFICACIONES.idEspecificacion=w_idEspecificacion;
IF(ESPECIFICACIONES_TIPO.idEspecificacion<>w_idEspecificacion)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2, w_idEspecificacion IN ESPECIFICACIONES.idEspecificacion%TYPE,w_repeticiones IN ESPECIFICACIONES.repeticiones%TYPE,
w_distancia IN ESPECIFICACIONES.distancia%TYPE,w_idEjercicio IN ESPECIFICACIONES.idEjercicio%TYPE, w_idMicrociclo IN ESPECIFICACIONES.idMicrociclo%TYPE, salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
ESPECIFICACION_TIPO ESPECIFICACIONES%ROWTYPE;
BEGIN 
    UPDATE ESPECIFICACIONES SET repeticiones=w_repeticiones,distancia=w_distancia,idEjercicio=w_idEjercicio,
    idMicrociclo = w_idMicrociclo WHERE idEspecificacion=w_idEspecificacion;
    SELECT * INTO ESPECIFICACION_TIPO FROM ESPECIFICACIONES WHERE ESPECIFICACIONES.idEspecificacion=w_idEspecificacion;
    IF(ESPECIFICACION_TIPO.repeticiones<>w_repeticiones
    OR ESPECIFICACION_TIPO.distancia<>w_distancia
    OR ESPECIFICACION_TIPO.idEjercicio<>w_idEjercicio
    OR ESPECIFICACION_TIPO.idMicrociclo<>w_idMicrociclo) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idEspecificacion IN ESPECIFICACIONES.idEspecificacion%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_ESPECIFICACIONES INTEGER;
    BEGIN
        DELETE FROM ESPECIFICACIONES WHERE idEspecificacion=w_idEspecificacion;
        SELECT COUNT(*) INTO N_ESPECIFICACIONES FROM ESPECIFICACIONES WHERE idEspecificacion=w_idEspecificacion;
        IF (N_ESPECIFICACIONES<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_ESPECIFICACIONES;
/




CREATE OR REPLACE PACKAGE PRUEBAS_COMPETICIONES AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_lugar IN COMPETICIONES.lugar%TYPE,w_nombre IN COMPETICIONES.nombre%TYPE,w_fecha IN COMPETICIONES.fecha%TYPE,w_tipo IN COMPETICIONES.tipo%TYPE,w_alcance IN COMPETICIONES.alcance%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idCompeticion IN COMPETICIONES.idCompeticion%TYPE, w_lugar IN COMPETICIONES.lugar%TYPE,w_nombre IN COMPETICIONES.nombre%TYPE,w_fecha IN COMPETICIONES.fecha%TYPE,w_tipo IN COMPETICIONES.tipo%TYPE,w_alcance IN COMPETICIONES.alcance%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idCompeticion IN COMPETICIONES.idCompeticion%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_COMPETICIONES;

/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_COMPETICIONES AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM COMPETICIONES ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_lugar IN COMPETICIONES.lugar%TYPE,w_nombre IN COMPETICIONES.nombre%TYPE,w_fecha IN COMPETICIONES.fecha%TYPE,w_tipo IN COMPETICIONES.tipo%TYPE,w_alcance IN COMPETICIONES.alcance%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
COMPETICIONES_TIPO COMPETICIONES%ROWTYPE;
w_idCompeticion Integer;
BEGIN 
nueva_competicion(w_lugar,w_nombre,w_fecha,w_tipo,w_alcance);
w_idCompeticion := seq_Competicion.currval;
SELECT * INTO COMPETICIONES_TIPO FROM COMPETICIONES WHERE COMPETICIONES.idCompeticion=w_idCompeticion;
IF(COMPETICIONES_TIPO.idCompeticion<>w_idCompeticion)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idCompeticion IN COMPETICIONES.idCompeticion%TYPE, w_lugar IN COMPETICIONES.lugar%TYPE,w_nombre IN COMPETICIONES.nombre%TYPE,w_fecha IN COMPETICIONES.fecha%TYPE,w_tipo IN COMPETICIONES.tipo%TYPE,w_alcance IN COMPETICIONES.alcance%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
COMPETICIONES_TIPO COMPETICIONES%ROWTYPE;
BEGIN 
    UPDATE COMPETICIONES SET lugar=w_lugar,nombre=w_nombre,fecha=w_fecha,tipo=w_tipo,alcance=w_alcance WHERE idCompeticion=w_idCompeticion;
    SELECT * INTO COMPETICIONES_TIPO FROM COMPETICIONES WHERE COMPETICIONES.idCompeticion=w_idCompeticion;
    IF(COMPETICIONES_TIPO.lugar<>w_lugar
    OR COMPETICIONES_TIPO.nombre<>w_nombre
    OR COMPETICIONES_TIPO.fecha<>w_fecha
    OR COMPETICIONES_TIPO.tipo<>w_tipo
     OR COMPETICIONES_TIPO.alcance<>w_alcance) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idCompeticion IN COMPETICIONES.idCompeticion%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_COMPETICIONES INTEGER;
    BEGIN
        DELETE FROM COMPETICIONES WHERE idCompeticion=w_idCompeticion;
        SELECT COUNT(*) INTO N_COMPETICIONES FROM COMPETICIONES WHERE idCompeticion=w_idCompeticion;
        IF (N_COMPETICIONES<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_COMPETICIONES;
/

CREATE OR REPLACE PACKAGE PRUEBAS_PAGOS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_fecha IN PAGOS.fecha%TYPE,
w_idAtleta IN PAGOS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idPago IN PAGOS.idPago%TYPE,w_fecha IN PAGOS.fecha%TYPE,
w_idAtleta IN PAGOS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idPago IN PAGOS.idPago%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_PAGOS;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_PAGOS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM PAGOS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_fecha IN PAGOS.fecha%TYPE,
w_idAtleta IN PAGOS.idAtleta%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
PAGO_TIPO PAGOS%ROWTYPE;
w_idPago INTEGER;
BEGIN 
introducir_pago(w_fecha,w_idAtleta);
w_idPago := seq_Pago.currval;
SELECT * INTO PAGO_TIPO FROM PAGOS WHERE PAGOS.idPago=w_idPago;
IF(PAGO_TIPO.idPago<>w_idPago)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2, w_idPago IN PAGOS.idPago%TYPE,w_fecha IN PAGOS.fecha%TYPE,
w_idAtleta IN PAGOS.idAtleta%TYPE, salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
PAGO_TIPO PAGOS%ROWTYPE;
BEGIN 
    UPDATE PAGOS SET fecha=w_fecha,idAtleta=w_idAtleta WHERE idPago=w_idPago;
    SELECT * INTO PAGO_TIPO FROM PAGOS WHERE idPago=w_idPago;
    IF(PAGO_TIPO.fecha<>w_fecha
    OR PAGO_TIPO.idAtleta<>w_idAtleta) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idPago IN PAGOS.idPago%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_PAGOS INTEGER;
    BEGIN
        DELETE FROM PAGOS WHERE idPago=w_idPago;
        SELECT COUNT(*) INTO N_PAGOS FROM PAGOS WHERE idPago=w_idPago;
        IF (N_PAGOS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_PAGOS;
/


CREATE OR REPLACE PACKAGE PRUEBAS_REUNIONES AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_fecha IN REUNIONES.fecha%TYPE,
w_lugar IN REUNIONES.lugar%TYPE,w_duracion IN REUNIONES.duracion%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idReunion IN REUNIONES.idReunion%TYPE,w_fecha IN REUNIONES.fecha%TYPE,
w_lugar IN REUNIONES.lugar%TYPE,w_duracion IN REUNIONES.duracion%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idReunion IN REUNIONES.idReunion%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_REUNIONES;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_REUNIONES AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM REUNIONES ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_fecha IN REUNIONES.fecha%TYPE,
w_lugar IN REUNIONES.lugar%TYPE,w_duracion IN REUNIONES.duracion%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
REUNION_TIPO REUNIONES%ROWTYPE;
w_idReunion INTEGER;
BEGIN 
nueva_reunion(w_fecha,w_lugar,w_duracion);
w_idReunion := seq_Reunion.currval;
SELECT * INTO REUNION_TIPO FROM REUNIONES WHERE REUNIONES.idReunion=w_idReunion;
IF(REUNION_TIPO.idReunion<>w_idReunion)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idReunion IN REUNIONES.idReunion%TYPE,w_fecha IN REUNIONES.fecha%TYPE,
w_lugar IN REUNIONES.lugar%TYPE,w_duracion IN REUNIONES.duracion%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
REUNION_TIPO REUNIONES%ROWTYPE;
BEGIN 
    UPDATE REUNIONES SET fecha=w_fecha,lugar=w_lugar,duracion=w_duracion WHERE idReunion=w_idReunion;
    SELECT * INTO REUNION_TIPO FROM REUNIONES WHERE idReunion=w_idReunion;
    IF(REUNION_TIPO.fecha<>w_fecha
    OR REUNION_TIPO.lugar<>w_lugar
    OR REUNION_TIPO.duracion<>w_duracion) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idReunion IN REUNIONES.idReunion%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_REUNIONES INTEGER;
    BEGIN
        DELETE FROM REUNIONES WHERE idReunion=w_idReunion;
        SELECT COUNT(*) INTO N_REUNIONES FROM REUNIONES WHERE idReunion=w_idReunion;
        IF (N_REUNIONES<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_REUNIONES;
/
CREATE OR REPLACE PACKAGE PRUEBAS_PRUEBAS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_Tipo IN PRUEBAS.Tipo%TYPE,w_Fecha IN PRUEBAS.Fecha%TYPE,w_idAtleta IN PRUEBAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idPrueba IN PRUEBAS.idPrueba%TYPE,w_Tipo IN PRUEBAS.Tipo%TYPE,w_Fecha IN PRUEBAS.Fecha%TYPE,w_idAtleta IN PRUEBAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idPrueba IN PRUEBAS.idPrueba%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_PRUEBAS;

/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_PRUEBAS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM PRUEBAS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_Tipo IN PRUEBAS.Tipo%TYPE,w_Fecha IN PRUEBAS.Fecha%TYPE,w_idAtleta IN PRUEBAS.idAtleta%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
PRUEBAS_TIPO PRUEBAS%ROWTYPE;
w_idPrueba Integer;
BEGIN 
nueva_prueba(w_Tipo,w_Fecha,w_idAtleta);
w_idPrueba := seq_Prueba.currval;
SELECT * INTO PRUEBAS_TIPO FROM PRUEBAS WHERE PRUEBAS.idPrueba=w_idPrueba;
IF(PRUEBAS_TIPO.idPrueba<>w_idPrueba)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idPrueba IN PRUEBAS.idPrueba%TYPE,w_Tipo IN PRUEBAS.Tipo%TYPE,w_Fecha IN PRUEBAS.Fecha%TYPE,w_idAtleta IN PRUEBAS.idAtleta%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
PRUEBAS_TIPO PRUEBAS%ROWTYPE;
BEGIN 
    UPDATE PRUEBAS SET Tipo=w_Tipo,Fecha=w_Fecha,idAtleta=w_idAtleta WHERE idPrueba=w_idPrueba;
    SELECT * INTO PRUEBAS_TIPO FROM PRUEBAS WHERE PRUEBAS.idPrueba=w_idPrueba;
    IF(PRUEBAS_TIPO.tipo<>w_tipo 
    OR PRUEBAS_TIPO.idAtleta<>w_idAtleta)THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idPrueba IN PRUEBAS.idPrueba%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_PRUEBAS INTEGER;
    BEGIN
        DELETE FROM PRUEBAS WHERE idPrueba=w_idPrueba;
        SELECT COUNT(*) INTO N_PRUEBAS FROM PRUEBAS WHERE idPrueba=w_idPrueba;
        IF (N_PRUEBAS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_PRUEBAS;
/


/*DOCUMENTOS*/
CREATE OR REPLACE PACKAGE PRUEBAS_DOCUMENTOS AS
    PROCEDURE INICIALIZAR;
    PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_descripcion IN documentos.descripcion%TYPE,w_rutaFichero IN documentos.rutaFichero%TYPE,w_idPago IN documentos.idPago%TYPE,w_idPrueba IN documentos.idPrueba%TYPE,salidaEsperada BOOLEAN);
    PROCEDURE ACTUALIZAR(w_idDOCUMENTO IN DOCUMENTOS.idDOCUMENTO%type, nombre_prueba VARCHAR2,w_descripcion IN documentos.descripcion%TYPE,w_rutaFichero IN documentos.rutaFichero%TYPE,w_idPago IN documentos.idPago%TYPE,w_idPrueba IN documentos.idPrueba%TYPE, salidaEsperada BOOLEAN);
    PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idDOCUMENTO IN DOCUMENTOS.idDOCUMENTO%type, salidaEsperada BOOLEAN);
END PRUEBAS_DOCUMENTOS;

/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_DOCUMENTOS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM DOCUMENTOS;
    END INICIALIZAR;

PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_descripcion IN documentos.descripcion%TYPE,w_rutaFichero IN documentos.rutaFichero%TYPE,w_idPago IN documentos.idPago%TYPE,w_idPrueba IN documentos.idPrueba%TYPE, salidaEsperada BOOLEAN)AS
    salida BOOLEAN :=true;
    DOCUMENTO_TIPO DOCUMENTOS%ROWTYPE;
    w_idDOCUMENTO Integer;
    BEGIN 
    introducir_documento(w_descripcion, w_rutaFichero, w_idPago, w_idPrueba);
    w_idDOCUMENTO := seq_DOCUMENTO.currval;
    SELECT * INTO DOCUMENTO_TIPO FROM DOCUMENTOS WHERE DOCUMENTOS.idDOCUMENTO=w_idDOCUMENTO;
    IF(DOCUMENTO_TIPO.idDOCUMENTO<>w_idDOCUMENTO)THEN
        salida:=false;
    END IF;
    COMMIT WORK;

    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));
        ROLLBACK;
    END INSERTAR;

PROCEDURE ACTUALIZAR(w_idDOCUMENTO IN DOCUMENTOS.idDOCUMENTO%type, nombre_prueba VARCHAR2,w_descripcion IN documentos.descripcion%TYPE,w_rutaFichero IN documentos.rutaFichero%TYPE,w_idPago IN documentos.idPago%TYPE,w_idPrueba IN documentos.idPrueba%TYPE, salidaEsperada BOOLEAN) AS
    salida BOOLEAN :=true;
    Resultado_TIPO DOCUMENTOS%ROWTYPE;
    BEGIN 
        UPDATE DOCUMENTOS SET descripcion=w_descripcion,rutaFichero=w_rutaFichero,idPago=w_idPago,idPrueba=w_idPrueba WHERE idDOCUMENTO=w_idDOCUMENTO;
        SELECT * INTO Resultado_TIPO FROM DOCUMENTOS WHERE DOCUMENTOS.idDOCUMENTO=w_idDOCUMENTO;
        IF(Resultado_TIPO.descripcion<>w_descripcion 
        OR Resultado_TIPO.rutaFichero<>w_rutaFichero
        OR Resultado_TIPO.idPago<>w_idPago
        OR Resultado_TIPO.idPrueba<>w_idPrueba) THEN 
            salida:=false;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));

        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;

PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idDOCUMENTO IN DOCUMENTOS.idDOCUMENTO%type, salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_DOCUMENTOS INTEGER;
    BEGIN
        DELETE FROM DOCUMENTOS WHERE idDOCUMENTO=w_idDOCUMENTO;
        SELECT COUNT(*) INTO N_DOCUMENTOS FROM DOCUMENTOS WHERE idDOCUMENTO=w_idDOCUMENTO;
        IF (N_DOCUMENTOS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));

        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_DOCUMENTOS;
/
CREATE OR REPLACE PACKAGE PRUEBAS_DIETAS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_descripcion IN DIETAS.descripcion%TYPE,
w_FechaFin IN DIETAS.FechaFin%TYPE,w_FechaInicio IN DIETAS.FechaInicio%TYPE,
w_idAtleta IN DIETAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idDieta IN DIETAS.idDieta%TYPE,w_descripcion IN DIETAS.descripcion%TYPE,
w_FechaFin IN DIETAS.FechaFin%TYPE,w_FechaInicio IN DIETAS.FechaInicio%TYPE,
w_idAtleta IN DIETAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idDieta IN DIETAS.idDieta%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_DIETAS;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_DIETAS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM DIETAS ;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_descripcion IN DIETAS.descripcion%TYPE,
w_FechaFin IN DIETAS.FechaFin%TYPE,w_FechaInicio IN DIETAS.FechaInicio%TYPE,
w_idAtleta IN DIETAS.idAtleta%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
DIETA_TIPO DIETAS%ROWTYPE;
w_idDieta INTEGER;
BEGIN 
nueva_dieta(w_descripcion,w_FechaFin,w_FechaInicio,w_idAtleta);
w_idDieta := seq_Dieta.currval;
SELECT * INTO DIETA_TIPO FROM DIETAS WHERE DIETAS.idDieta=w_idDieta;
IF(DIETA_TIPO.idDieta<>w_idDieta)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2, w_idDieta IN DIETAS.idDieta%TYPE,w_descripcion IN DIETAS.descripcion%TYPE,w_FechaFin IN DIETAS.FechaFin%TYPE,w_FechaInicio IN DIETAS.FechaInicio%TYPE,
w_idAtleta IN DIETAS.idAtleta%TYPE, salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
DIETA_TIPO DIETAS%ROWTYPE;
BEGIN 
    UPDATE DIETAS SET descripcion=w_descripcion,FechaFin=w_FechaFin,FechaInicio=w_FechaInicio,idAtleta=w_idAtleta WHERE idDieta=w_idDieta;
    SELECT * INTO DIETA_TIPO FROM DIETAS WHERE idDieta=w_idDieta;
    IF(DIETA_TIPO.descripcion<>w_descripcion
    OR DIETA_TIPO.idAtleta<>w_idAtleta
    OR DIETA_TIPO.FechaFin<> w_FechaFin
    OR DIETA_TIPO.FechaInicio<> w_FechaInicio) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idDieta IN DIETAS.idDieta%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_DIETAS INTEGER;
    BEGIN
        DELETE FROM DIETAS WHERE idDieta=w_idDieta;
        SELECT COUNT(*) INTO N_DIETAS FROM DIETAS WHERE idDieta=w_idDieta;
        IF (N_DIETAS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_DIETAS;
/
CREATE OR REPLACE PACKAGE PRUEBAS_CONSULTAS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_Tipo IN CONSULTAS.Tipo%TYPE,
w_Tema IN CONSULTAS.Tema%TYPE,w_Descripcion IN CONSULTAS.Descripcion%TYPE,w_idAtleta IN CONSULTAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idConsulta IN CONSULTAS.idConsulta%TYPE,
w_Tipo IN CONSULTAS.Tipo%TYPE,w_Tema IN CONSULTAS.Tema%TYPE,w_Descripcion IN CONSULTAS.Descripcion%TYPE,w_idAtleta IN CONSULTAS.idAtleta%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idConsulta IN CONSULTAS.idConsulta%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_CONSULTAS;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_CONSULTAS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM CONSULTAS;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,
w_Tipo IN CONSULTAS.Tipo%TYPE,w_Tema IN CONSULTAS.Tema%TYPE,w_Descripcion IN CONSULTAS.Descripcion%TYPE,w_idAtleta IN CONSULTAS.idAtleta%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN := true;
CONSULTAS_TIPO CONSULTAS%ROWTYPE;
w_idConsulta CONSULTAS.idConsulta%TYPE;
BEGIN 
nueva_consulta(w_Tipo,w_Tema,w_Descripcion,w_idAtleta);
w_idConsulta := seq_Consulta.currval;
SELECT * INTO CONSULTAS_TIPO FROM CONSULTAS WHERE CONSULTAS.idConsulta=w_idConsulta;
IF(CONSULTAS_TIPO.idConsulta<>w_idConsulta)
THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||': '|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idConsulta IN CONSULTAS.idConsulta%TYPE,
w_Tipo IN CONSULTAS.Tipo%TYPE,w_Tema IN CONSULTAS.Tema%TYPE,w_Descripcion IN CONSULTAS.Descripcion%TYPE
,w_idAtleta IN CONSULTAS.idAtleta%TYPE,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=true;
CONSULTA_TIPO CONSULTAS%ROWTYPE;
BEGIN 
    UPDATE CONSULTAS SET tipo=w_Tipo,Tema=w_Tema,Descripcion = w_Descripcion,idAtleta=w_idAtleta WHERE idConsulta=w_idConsulta;
    SELECT * INTO CONSULTA_TIPO FROM CONSULTAS WHERE idConsulta=w_idConsulta;
    IF(CONSULTA_TIPO.Tipo<>w_Tipo
    OR CONSULTA_TIPO.Tema<>w_Tema
    OR CONSULTA_TIPO.Descripcion<>w_Descripcion
    OR CONSULTA_TIPO.idAtleta<>w_idAtleta) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idConsulta IN CONSULTAS.idConsulta%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_CONSULTAS INTEGER;
    BEGIN
        DELETE FROM CONSULTAS WHERE idConsulta=w_idConsulta;
        SELECT COUNT(*) INTO N_CONSULTAS FROM CONSULTAS WHERE idConsulta=w_idConsulta;
        IF (N_CONSULTAS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_CONSULTAS;
/



CREATE OR REPLACE PACKAGE PRUEBAS_ASISTENCIAS AS
PROCEDURE INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_idAtleta IN ASISTENCIAS.idAtleta%TYPE,
w_idReunion IN ASISTENCIAS.idReunion%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2,w_idAsistencia IN ASISTENCIAS.idAsistencia%TYPE,w_idAtleta IN ASISTENCIAS.idAtleta%TYPE,
w_idReunion IN ASISTENCIAS.idReunion%TYPE,salidaEsperada BOOLEAN);
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idAsistencia IN ASISTENCIAS.idAsistencia%TYPE,salidaEsperada BOOLEAN);
END PRUEBAS_ASISTENCIAS;
/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_ASISTENCIAS AS
PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM ASISTENCIAS;
    END INICIALIZAR;
PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_idAtleta IN ASISTENCIAS.idAtleta%TYPE,
w_idReunion IN ASISTENCIAS.idReunion%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
ASISTENCIAS_TIPO ASISTENCIAS%ROWTYPE;
w_idAsistencia INTEGER;
BEGIN 
nueva_asistencia(w_idAtleta,w_idReunion);
w_idAsistencia := seq_Asistencia.currval;
SELECT * INTO ASISTENCIAS_TIPO FROM ASISTENCIAS WHERE ASISTENCIAS.idAsistencia=w_idAsistencia;
IF(ASISTENCIAS_TIPO.idAsistencia<>w_idAsistencia)THEN
    salida:=false;
END IF;
COMMIT WORK;

DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(false,salidaEsperada));
    ROLLBACK;
END INSERTAR;

PROCEDURE ACTUALIZAR(nombre_prueba VARCHAR2, w_idAsistencia IN ASISTENCIAS.idAsistencia%TYPE,w_idAtleta IN ASISTENCIAS.idAtleta%TYPE,
w_idReunion IN ASISTENCIAS.idReunion%TYPE,salidaEsperada BOOLEAN)AS
salida BOOLEAN :=true;
ASISTENCIA_TIPO ASISTENCIAS%ROWTYPE;
BEGIN 
    UPDATE ASISTENCIAS SET idAtleta=w_idAtleta,idReunion=w_idReunion WHERE idAsistencia=w_idAsistencia;
    SELECT * INTO ASISTENCIA_TIPO FROM ASISTENCIAS WHERE idAsistencia=w_idAsistencia;
    IF(ASISTENCIA_TIPO.idAtleta<>w_idAtleta
    OR ASISTENCIA_TIPO.idReunion<>w_idReunion) THEN 
    salida:=false;
    END IF;
    COMMIT WORK;
    DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;
    
PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idAsistencia IN ASISTENCIAS.idAsistencia%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_ASISTENCIAS INTEGER;
    BEGIN
        DELETE FROM ASISTENCIAS WHERE idAsistencia=w_idAsistencia;
        SELECT COUNT(*) INTO N_ASISTENCIAS FROM ASISTENCIAS WHERE idAsistencia=w_idAsistencia;
        IF (N_ASISTENCIAS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;
         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_ASISTENCIAS;
/

/*RESULTADOS*/
CREATE OR REPLACE PACKAGE PRUEBAS_RESULTADOS AS
    PROCEDURE INICIALIZAR;
    PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_idAtleta IN RESULTADOS.idAtleta%type,w_idCompeticion IN RESULTADOS.idCompeticion%type,w_prueba IN RESULTADOS.prueba%type,w_marca IN RESULTADOS.marca%type,w_posicion IN RESULTADOS.posicion%type, salidaEsperada BOOLEAN);
    PROCEDURE ACTUALIZAR(w_idResultado IN RESULTADOS.idResultado%type, nombre_prueba VARCHAR2,w_idAtleta IN RESULTADOS.idAtleta%type,w_idCompeticion IN RESULTADOS.idCompeticion%type,w_prueba IN RESULTADOS.prueba%type,w_marca IN RESULTADOS.marca%type,w_posicion IN RESULTADOS.posicion%type, salidaEsperada BOOLEAN);
    PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idResultado IN RESULTADOS.idResultado%type, salidaEsperada BOOLEAN);
END PRUEBAS_RESULTADOS;

/
CREATE OR REPLACE PACKAGE BODY PRUEBAS_RESULTADOS AS

PROCEDURE INICIALIZAR AS
    BEGIN 
        DELETE FROM RESULTADOS;
    END INICIALIZAR;

PROCEDURE INSERTAR(nombre_prueba VARCHAR2,w_idAtleta IN RESULTADOS.idAtleta%type,w_idCompeticion IN RESULTADOS.idCompeticion%type,w_prueba IN RESULTADOS.prueba%type,w_marca IN RESULTADOS.marca%type,w_posicion IN RESULTADOS.posicion%type, salidaEsperada BOOLEAN)AS
    salida BOOLEAN :=true;
    Resultado_TIPO RESULTADOS%ROWTYPE;
    w_idResultado Integer;
    BEGIN 
    nuevo_resultado(w_idAtleta,w_idCompeticion,w_prueba,w_marca,w_posicion);
    w_idResultado := seq_Resultado.currval;
    SELECT * INTO Resultado_TIPO FROM RESULTADOS WHERE RESULTADOS.idResultado=w_idResultado;
    IF(Resultado_TIPO.idResultado<>w_idResultado)THEN
        salida:=false;
    END IF;
    COMMIT WORK;

    DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(nombre_prueba||':'|| ASSERT_EQUALS(salida,salidaEsperada));
        ROLLBACK;
    END INSERTAR;

PROCEDURE ACTUALIZAR(w_idResultado IN RESULTADOS.idResultado%type, nombre_prueba VARCHAR2,w_idAtleta IN RESULTADOS.idAtleta%type,w_idCompeticion IN RESULTADOS.idCompeticion%type,w_prueba IN RESULTADOS.prueba%type,w_marca IN RESULTADOS.marca%type,w_posicion IN RESULTADOS.posicion%type, salidaEsperada BOOLEAN) AS
    salida BOOLEAN :=true;
    Resultado_TIPO RESULTADOS%ROWTYPE;
    BEGIN 
        UPDATE RESULTADOS SET idAtleta=w_idAtleta,idCompeticion=w_idCompeticion,prueba=w_prueba,marca=w_marca,posicion=w_posicion WHERE idResultado=w_idResultado;
        SELECT * INTO Resultado_TIPO FROM RESULTADOS WHERE RESULTADOS.idResultado=w_idResultado;
        IF(Resultado_TIPO.idAtleta<>w_idAtleta 
        OR Resultado_TIPO.idCompeticion<>w_idCompeticion
        OR Resultado_TIPO.prueba<>w_prueba
        OR Resultado_TIPO.marca<>w_marca
        OR Resultado_TIPO.posicion<>w_posicion
        OR Resultado_TIPO.idAtleta<>w_idAtleta) THEN 
            salida:=false;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));

        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ACTUALIZAR;

PROCEDURE ELIMINAR(nombre_prueba VARCHAR2,w_idResultado IN RESULTADOS.idResultado%TYPE,salidaEsperada BOOLEAN) AS
    salida BOOLEAN:= TRUE;
    N_RESULTADOS INTEGER;
    BEGIN
        DELETE FROM RESULTADOS WHERE idResultado=w_idResultado;
        SELECT COUNT(*) INTO N_RESULTADOS FROM RESULTADOS WHERE idResultado=w_idResultado;
        IF (N_RESULTADOS<>0)THEN 
            salida:=false;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, salidaEsperada));

        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(false, salidaEsperada));
            ROLLBACK;
    END ELIMINAR;
END PRUEBAS_RESULTADOS;
/
