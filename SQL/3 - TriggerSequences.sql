CREATE OR REPLACE TRIGGER T_seq_atleta --Inserta el valor de la secuencia seq_Atletas en el valor idAtleta de la tabla Atletas
BEFORE INSERT ON ATLETAS
FOR EACH ROW
BEGIN
    SELECT seq_Atletas.nextval into :NEW.idAtleta from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_microciclo --Inserta el valor de la secuencia seq_Microciclo en el valor idMicrociclo de la tabla Microciclos
BEFORE INSERT ON MICROCICLOS
FOR EACH ROW
BEGIN
    SELECT seq_Microciclo.nextval into :NEW.idMicrociclo from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_ejercicio --Inserta el valor de la secuencia seq_Ejercicio en el valor idEjercicio de la tabla Ejercicios
BEFORE INSERT ON EJERCICIOS
FOR EACH ROW
BEGIN
    SELECT seq_Ejercicio.nextval into :NEW.idEjercicio from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_especificacion --Inserta el valor de la secuencia seq_Especificacion en el valor idEspecificacion de la tabla Especificaciones
BEFORE INSERT ON ESPECIFICACIONES
FOR EACH ROW
BEGIN
    SELECT seq_Especificacion.nextval into :NEW.idEspecificacion from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_competicion --Inserta el valor de la secuencia seq_Competicion en el valor idCompeticion de la tabla Competiciones
BEFORE INSERT ON COMPETICIONES
FOR EACH ROW
BEGIN
    SELECT seq_Competicion.nextval into :NEW.idCompeticion from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_pago --Inserta el valor de la secuencia seq_Pago en el valor idPago de la tabla Pagos
BEFORE INSERT ON PAGOS
FOR EACH ROW
BEGIN
    SELECT seq_Pago.nextval into :NEW.idPago from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_reunion --Inserta el valor de la secuencia seq_Reunion en el valor idReunion de la tabla Reuniones
BEFORE INSERT ON REUNIONES
FOR EACH ROW
BEGIN
    SELECT seq_Reunion.nextval into :NEW.idReunion from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_prueba --Inserta el valor de la secuencia seq_Prueba en el valor idPrueba de la tabla Pruebas
BEFORE INSERT ON PRUEBAS
FOR EACH ROW
BEGIN
    SELECT seq_Prueba.nextval into :NEW.idPrueba from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_documento --Inserta el valor de la secuencia seq_Documento en el valor idDocumento de la tabla Documentos
BEFORE INSERT ON DOCUMENTOS
FOR EACH ROW
BEGIN
    SELECT seq_Documento.nextval into :NEW.idDocumento from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_consulta --Inserta el valor de la secuencia seq_Consulta en el valor idConsulta de la tabla Consultas
BEFORE INSERT ON CONSULTAS
FOR EACH ROW
BEGIN
    SELECT seq_Consulta.nextval into :NEW.idConsulta from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_dieta --Inserta el valor de la secuencia seq_Dieta en el valor idDieta de la tabla Dietas
BEFORE INSERT ON DIETAS
FOR EACH ROW
BEGIN
    SELECT seq_Dieta.nextval into :NEW.idDieta from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_asistencia --Inserta el valor de la secuencia seq_Asistencia en el valor idAsistencia de la tabla Asistencias
BEFORE INSERT ON ASISTENCIAS
FOR EACH ROW
BEGIN
    SELECT seq_Asistencia.nextval into :NEW.idAsistencia from DUAL;
END;
/

CREATE OR REPLACE TRIGGER T_seq_resultado --Inserta el valor de la secuencia seq_Resultado en el valor idResultado de la tabla Resultados
BEFORE INSERT ON RESULTADOS
FOR EACH ROW
BEGIN
    SELECT seq_Resultado.nextval into :NEW.idResultado from DUAL;
END;
/
CREATE OR REPLACE TRIGGER T_seq_Feedback --Inserta el valor de la secuencia seq_Feedback en el valor idFeedback de la tabla Feedbacks
BEFORE INSERT ON FEEDBACKS
FOR EACH ROW
BEGIN
    SELECT seq_Feedback.nextval into :NEW.idFeedback from DUAL;
END;
/
CREATE OR REPLACE TRIGGER T_seq_Media --Inserta el valor de la secuencia seq_Media en el valor idMedia de la tabla Media
BEFORE INSERT ON MEDIA
FOR EACH ROW
BEGIN
    SELECT seq_Media.nextval into :NEW.idMedia from DUAL;
END;
/
