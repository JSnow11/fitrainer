/*GENERAR INFORMES, REQUISITOS FUNCIONALES*/

/*TODOS LOS ATLETAS*/
CREATE OR REPLACE PROCEDURE mostrar_atletas(w_genero IN ATLETAS.genero%type,w_estadoFisico IN ATLETAS.estadoFisico%type, 
        w_edad IN ATLETAS.edad%type, w_activo IN ATLETAS.activo%type) AS
    CURSOR c IS
        SELECT * FROM ATLETAS
                ORDER BY idAtleta;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('ATLETAS: ');
    DBMS_OUTPUT.PUT_LINE('FILTROS: genero-' || w_genero ||', estado fisico-'|| w_estadoFisico ||', edad-'|| w_edad ||', activo-'|| w_activo);
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    FOR fila IN c LOOP
                IF((fila.genero = w_genero or w_genero is null) 
                        and (fila.estadoFisico = w_estadoFisico or w_estadoFisico is null) 
                        and (fila.edad = w_edad or w_edad is null)
                        and (fila.activo = w_activo or w_activo is null))
                    THEN
                        DBMS_OUTPUT.PUT_LINE('ID: ' || fila.idAtleta ||', ' || fila.nombre||' '||fila.apellidos);
                END IF;
    END LOOP;
END;
/

/*EJERCICIOS PARA UN MICROCICLO*/
CREATE OR REPLACE PROCEDURE ejercicios_microciclo
(w_idMicrociclo IN MICROCICLOS.idMicrociclo%TYPE) IS
    CURSOR c IS
        SELECT idEjercicio, titulo, EJERCICIOS.tipo, repeticiones, distancia, descripcion 
                FROM EJERCICIOS NATURAL JOIN ESPECIFICACIONES
                WHERE idMicrociclo = w_idMicrociclo
                ORDER BY idEjercicio;

    microciclo MICROCICLOS%ROWTYPE;

BEGIN
    SELECT * INTO microciclo FROM MICROCICLOS WHERE idMicrociclo = w_idMicrociclo;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE( 'MICROCICLO: ' || w_idMicrociclo);
    DBMS_OUTPUT.PUT_LINE( 'TIPO: ' || microciclo.tipo);
    DBMS_OUTPUT.PUT_LINE( 'INICIO: ' || microciclo.fechaInicio);
    DBMS_OUTPUT.PUT_LINE( 'FIN: ' || microciclo.fechaFin);
    DBMS_OUTPUT.PUT_LINE( 'DIAS RESTANTES: ' || dias_restantes_fin(microciclo.fechaFin));
    DBMS_OUTPUT.PUT_LINE('INSTRUCCIONES: ');
    DBMS_OUTPUT.PUT_LINE(microciclo.descripcion);

    DBMS_OUTPUT.PUT_LINE( '----------------------------------------------------');
    FOR fila IN c LOOP
        DBMS_OUTPUT.PUT_LINE( 'EJERCICIO: ' || fila.titulo);
        DBMS_OUTPUT.PUT_LINE( 'TIPO: ' || fila.tipo);
        DBMS_OUTPUT.PUT_LINE( 'REPETICIONES: ' || fila.repeticiones);
        DBMS_OUTPUT.PUT_LINE( 'DISTANCIA: ' || fila.distancia);
        DBMS_OUTPUT.PUT_LINE( 'INSTRUCCIONES: ' || fila.descripcion );
        DBMS_OUTPUT.PUT_LINE( '' );
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( '----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE( 'RECUPERACION: ' || microciclo.recuperacion);
END;
/

/*ASISTENTES*/
CREATE OR REPLACE PROCEDURE mostrar_asistentes_reunion
(w_idReunion IN REUNIONES.idReunion%TYPE) IS
    CURSOR c IS
        SELECT idAtleta,nombre,apellidos 
                FROM ATLETAS NATURAL JOIN ASISTENCIAS
                WHERE idReunion = w_idReunion
                ORDER BY idAtleta;

        total INTEGER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('ASISTENTES REUNION: ' ||w_idReunion);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');

    FOR fila IN c LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || fila.idAtleta ||', ' || fila.nombre||' '||fila.apellidos);
        total:=total + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTAL ASISTENTES: ' || total);
END;
/

/*ASISTENTES*/
CREATE OR REPLACE PROCEDURE mostrar_asistentes_competicion
(w_idCompeticion IN COMPETICIONES.idCompeticion%TYPE) IS
    CURSOR c IS
        SELECT idAtleta,nombre,apellidos 
                FROM ATLETAS NATURAL JOIN RESULTADOS
                WHERE idCompeticion = w_idCompeticion
                ORDER BY idAtleta;
    total INTEGER :=0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('ASISTENTES COMPETICION '||w_idCompeticion ||':');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    FOR fila IN c LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || fila.idAtleta ||', ' || fila.nombre||' '||fila.apellidos);
        total:=total + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTAL ASISTENTES: '||total);
END;
/

/*PAGOS*/
CREATE OR REPLACE PROCEDURE comprobar_ultimo_pago
(w_idAtleta IN ATLETAS.idAtleta%TYPE) IS
    ultima_fecha date;
    comprobante DOCUMENTOS.rutaFichero%TYPE;
BEGIN
    SELECT MAX(fecha) INTO ultima_fecha FROM PAGOS WHERE idAtleta = w_idAtleta;
    SELECT rutaFichero INTO comprobante FROM DOCUMENTOS NATURAL JOIN PAGOS WHERE fecha = ultima_fecha and idAtleta = w_idAtleta;
    DBMS_OUTPUT.PUT_LINE('COMPROBAR ULTIMO PAGO:');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Fecha de pago: '|| ultima_fecha);
    DBMS_OUTPUT.PUT_LINE('URL Comprobante: '|| comprobante);
    DBMS_OUTPUT.PUT_LINE('Este es el ultimo pago que ha introducido en el sistema');

END;
/

/*PERFIL ATLETA*/
CREATE OR REPLACE PROCEDURE perfil_atleta
(w_idAtleta IN ATLETAS.idAtleta%TYPE) IS

atleta ATLETAS%ROWTYPE;
n_microciclos INTEGER;
n_comp INTEGER;
n_km NUMBER(5,1);
CURSOR c IS
    SELECT * 
        FROM (SELECT * FROM RESULTADOS NATURAL JOIN COMPETICIONES
        ORDER BY COMPETICIONES.fecha DESC)
        WHERE idAtleta = w_idAtleta and ROWNUM < 4;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('DATOS: ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    SELECT * INTO atleta FROM ATLETAS WHERE idAtleta = w_idAtleta;
    DBMS_OUTPUT.PUT_LINE('ID: ' || atleta.idAtleta);
    DBMS_OUTPUT.PUT_LINE('Atleta: ' || atleta.nombre||' '||atleta.apellidos);
    DBMS_OUTPUT.PUT_LINE('Genero: ' || atleta.genero);
    DBMS_OUTPUT.PUT_LINE('Contacto: ' || atleta.telefono||', '||atleta.correo);
    DBMS_OUTPUT.PUT_LINE('Direccion: ' || atleta.direccion);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('ESTADO ACTUAL: ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Edad: ' || atleta.edad);
    DBMS_OUTPUT.PUT_LINE('Estado Fisico: ' || atleta.estadoFisico);
    DBMS_OUTPUT.PUT_LINE('Activo: ' || atleta.activo);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('ULTIMOS RESULTADOS: ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    FOR fila IN c LOOP
        DBMS_OUTPUT.PUT_LINE('Fecha: '||fila.fecha);
        DBMS_OUTPUT.PUT_LINE('Prueba: ' || fila.prueba);
        DBMS_OUTPUT.PUT_LINE('Marca: ' || fila.marca);
        DBMS_OUTPUT.PUT_LINE('Posicion: ' || fila.posicion);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('STATS TEMPORADA: ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    SELECT SUM(distancia * repeticiones) 
        INTO n_km
        FROM ESPECIFICACIONES NATURAL JOIN MICROCICLOS
        WHERE idAtleta = w_idAtleta AND EXTRACT(YEAR FROM fechaInicio) = EXTRACT(YEAR FROM sysdate);
    SELECT COUNT(*)
        INTO n_microciclos
        FROM MICROCICLOS
        WHERE idAtleta = w_idAtleta AND EXTRACT(YEAR FROM fechaInicio) = EXTRACT(YEAR FROM sysdate);
    SELECT COUNT(*)
        INTO n_comp
        FROM COMPETICIONES NATURAL JOIN RESULTADOS
        WHERE idAtleta = w_idAtleta AND EXTRACT(YEAR FROM fecha) = EXTRACT(YEAR FROM sysdate);
    DBMS_OUTPUT.PUT_LINE('KM corridos esta temporada : ' || n_km||' km');
    DBMS_OUTPUT.PUT_LINE('Microciclos realizados esta temporada: ' || n_microciclos);
    DBMS_OUTPUT.PUT_LINE('Participaciones en competiciones: ' || n_comp);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('STATS TOTALES: ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    SELECT SUM(distancia * repeticiones) 
        INTO n_km
        FROM ESPECIFICACIONES NATURAL JOIN MICROCICLOS
        WHERE idAtleta = w_idAtleta ;
    SELECT COUNT(*)
        INTO n_microciclos
        FROM MICROCICLOS
        WHERE idAtleta = w_idAtleta;
    SELECT COUNT(*)
        INTO n_comp
        FROM COMPETICIONES NATURAL JOIN RESULTADOS
        WHERE idAtleta = w_idAtleta;
    DBMS_OUTPUT.PUT_LINE('KM corridos: ' || n_km ||' km');
    DBMS_OUTPUT.PUT_LINE('Microciclos realizados: ' || n_microciclos);
    DBMS_OUTPUT.PUT_LINE('Participaciones en competiciones: ' || n_comp);

    DBMS_OUTPUT.PUT_LINE('');
END;
/

SET SERVEROUTPUT ON;    
exec mostrar_atletas('M',null,null, 1   );
exec mostrar_asistentes_reunion(1);
exec mostrar_asistentes_competicion(1);
exec comprobar_ultimo_pago(1);
exec ejercicios_microciclo(4);
exec perfil_atleta(4);


/