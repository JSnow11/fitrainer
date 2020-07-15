/*RN1*/
/*Este trigger coge la ultima fecha de la tabla consultas y la almacena en la variable fechaUltima mirando que el idAtleta y el tipo sean iguales.
A la nueva fecha se le resta el valor almacenado en fechaUltima que davuelve un numero de días. Si entre la primera consulta y la nueva a pasado más de un día,
y el idAtleta y el tipo de la consulta es la misma entonces salta el trigger.*/
CREATE OR REPLACE TRIGGER Limite_Consulta
    BEFORE INSERT ON CONSULTAS
    FOR EACH ROW
    DECLARE
        diferencia INTEGER;
        fechaultima DATE;
        
    BEGIN
        
        SELECT MAX(CONSULTAS.Fecha) INTO fechaultima FROM CONSULTAS WHERE :NEW.idAtleta = idAtleta AND :NEW.Tipo = Tipo;
        SELECT :NEW.Fecha - fechaultima INTO diferencia FROM DUAL; 
        
        IF (diferencia < 1)
          THEN raise_application_error(-20000,:NEW.idConsulta||' No se pude realizar mas de una consulta del mismo tipo en un dia');
        END IF;
    END;
/
/*RN2*/
/*Coge atributo de la tabla atleta y lo almacena en la variable actividad.
Si el valor de actividad es 0, salta el trigger e impide que al atleta inactivo se le pueda asignar una reunión.*/

CREATE OR REPLACE TRIGGER Bloqueo_Reunion
    BEFORE INSERT ON ASISTENCIAS
    FOR EACH ROW
    DECLARE
        actividad NUMBER(1,0);

    BEGIN 
        SELECT activo INTO actividad FROM ATLETAS WHERE idAtleta = :NEW.idAtleta;

        IF(actividad = 0)

            THEN raise_application_error(-20100,:NEW.idAsistencia||' Bloqueado, no se puede introducir la asistencia, puede que se haya dado de baja o no haya pagado el ultimo mes');
        END IF;
    END;
/
/*Coge atributo de la tabla atleta y lo almacena en la variable actividad.
Si el valor de actividad es 0, salta el trigger e impide que al atleta inactivo se le pueda asignar una consulta.*/

CREATE OR REPLACE TRIGGER Bloqueo_Consulta
    BEFORE INSERT ON CONSULTAS
    FOR EACH ROW
    DECLARE
        actividad NUMBER(1,0);

    BEGIN 
        SELECT activo INTO actividad FROM ATLETAS WHERE idAtleta = :NEW.idAtleta;

        IF(actividad = 0)
            THEN raise_application_error(-20200,:NEW.idConsulta||' El atleta no esta activo, no se puede introducir la consulta, puede que se haya dado de baja o no haya pagado el Ãºltimo mes');
        END IF;
    END;
/
/*Coge atributo de la tabla atleta y lo almacena en la variable actividad.
Si el valor de actividad es 0, salta el trigger e impide que al atleta inactivo se le pueda asignar un microciclo.*/

CREATE OR REPLACE TRIGGER Bloqueo_Microciclo
    BEFORE INSERT ON MICROCICLOS
    FOR EACH ROW
    DECLARE
        actividad NUMBER(1,0);

    BEGIN 
        SELECT activo INTO actividad FROM ATLETAS WHERE idAtleta = :NEW.idAtleta;

        IF(actividad = 0)
           THEN raise_application_error(-20300,:NEW.idMicrociclo||' El atleta no esta activo, no se puede introducir el microciclo, puede que se haya dado de baja o no haya pagado el Ãºltimo mes');
        END IF;
    END;
/
/*Coge atributo de la tabla atleta y lo almacena en la variable actividad.
Si el valor de actividad es 0, salta el trigger e impide que al atleta inactivo se le pueda asignar una dieta.*/

CREATE OR REPLACE TRIGGER Bloqueo_Dieta
    BEFORE INSERT ON DIETAS
    FOR EACH ROW
    DECLARE
        actividad NUMBER(1,0);

    BEGIN 
        SELECT activo INTO actividad FROM ATLETAS WHERE idAtleta = :NEW.idAtleta;


        IF(actividad = 0)
           THEN raise_application_error(-20400,:NEW.idDieta||' El atleta no esta activo, no se puede introducir la dieta, puede que se haya dado de baja o no haya pagado el Ãºltimo mes');
        END IF;
    END;
/
/*RN3*/
/*este trigger cogue la fechaFin mas reciente de la tabla microciclos comrobando que idAtleta es igual y la almacena en la variable fechaultima.
A la nueva fechaFin del microciclo se le resta la variable fechaultima y se almacena en la variable diferencia. Si la diferencia es menor que 7 entonces el trigger
saltará, impidiendo que un atleta siga a más de un microciclo en una semana.*/
CREATE OR REPLACE TRIGGER Limite_Microciclos
    BEFORE INSERT ON MICROCICLOS
    FOR EACH ROW
    DECLARE
        diferencia INTEGER;
        fechaultima DATE;

    BEGIN
        SELECT MAX(MICROCICLOS.fechaFin) INTO fechaultima FROM MICROCICLOS WHERE :NEW.idAtleta = idAtleta;
        SELECT :NEW.fechaFin - fechaultima INTO diferencia FROM DUAL; 

        IF (diferencia < 7)
          THEN raise_application_error(-20500,:NEW.idMicrociclo||' No se puede seguir mas de un microciclo a la vez en una misma semana');
        END IF;
    END;
/
/*RN4*/
/*Este trigger impide que un atleta de con un estado físico asignado solo pueda seguir microciclos del mismo tipo.
En el caso de que a un atleta intente seguir un microciclo que tengan estado físico diferente al suyo saltará el trigger*/
CREATE OR REPLACE TRIGGER Mismo_Tipo_Microciclo
    BEFORE INSERT ON MICROCICLOS
    FOR EACH ROW
    DECLARE
    tipoA VARCHAR2(40);
    
    BEGIN
        SELECT estadoFisico into tipoA FROM ATLETAS WHERE :NEW.idAtleta = idAtleta;

        IF (tipoA!=:NEW.tipo)
          THEN raise_application_error(-20600,:NEW.idMicrociclo||' No se puede introducir este microciclo porque no coincide con el estado del atleta');
        END IF;
    END;
/
/*RN5*/
/*cogue el atributo activo de la tabla atletas y lo almacena en la variable actividad, comparando las id de Atleta.
Si actividad tiene como valor 0, saltará en trigger. En definitiva, este microciclo impide que a un atleta inactivo se le pueda asignar un microciclo.*/

CREATE OR REPLACE TRIGGER Atletas_Inactivos
    BEFORE INSERT ON MICROCICLOS
    FOR EACH ROW
    DECLARE
    actividad NUMBER(1,0);

    BEGIN
        SELECT activo INTO actividad FROM ATLETAS WHERE :NEW.idAtleta = idAtleta;

        IF(actividad = 0)
            THEN raise_application_error(-20700,:NEW.idMicrociclo||' A un atleta inactivo no se le puede asignar un microciclo');
        END IF;
    END;
/

/*ANNADE LA FECHA FIN AUTOMATICAMENTE*/
/* este trigger usa la función dias_mas para sumarle a la fecha de inicio del microciclo 7 días y almacenarla en la fecha fin del microciclo.*/
CREATE OR REPLACE TRIGGER fecha_inicio_fin
    BEFORE INSERT ON MICROCICLOS
    FOR EACH ROW

    BEGIN 
        SELECT dias_mas(:NEW.fechaInicio) into :NEW.fechaFin FROM DUAL;
    END;
/

