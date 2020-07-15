/*codigo para la automatizacion del iniciado de tablas*/
DROP TABLE RESULTADOS;
DROP TABLE ASISTENCIAS;
DROP TABLE CONSULTAS;
DROP TABLE DIETAS;
DROP TABLE DOCUMENTOS;
DROP TABLE PRUEBAS;
DROP TABLE REUNIONES;
DROP TABLE PAGOS;
DROP TABLE COMPETICIONES;
DROP TABLE ESPECIFICACIONES;
DROP TABLE EJERCICIOS;
DROP TABLE MEDIA;
DROP TABLE FEEDBACKS;
DROP TABLE MICROCICLOS;
DROP TABLE ATLETAS;


CREATE TABLE ATLETAS(
    idAtleta INTEGER NOT NULL,
    nombre VARCHAR2(20) NOT NULL,
    apellidos VARCHAR2(50) NOT NULL,
    edad INTEGER NOT NULL,
    genero CHAR(1) NOT NULL CONSTRAINT chkGenero CHECK(genero IN('M','F')),
    telefono INTEGER NOT NULL,
    direccion VARCHAR2(50) NOT NULL,
    estadoFisico VARCHAR2(50) CONSTRAINT chkEstadoFisico CHECK(estadoFisico IN('Alto rendimiento','Buena forma', 'Baja forma', 'Lesionado')) NOT NULL,
    correo VARCHAR2(50) NOT NULL,
    contrasenna VARCHAR2(40) NOT NULL,
    activo NUMBER(1,0) CONSTRAINT chkActivo CHECK(activo IN(1,0)) NOT NULL,
    PRIMARY KEY(idAtleta),
    UNIQUE(correo)
);

CREATE TABLE MICROCICLOS(
    idMicrociclo INTEGER NOT NULL ,
    tipo VARCHAR2(50) CONSTRAINT chkTipoM CHECK(tipo IN('Alto rendimiento','Buena forma', 'Baja forma', 'Lesionado')) NOT NULL,
    descripcion VARCHAR2(500),
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    recuperacion VARCHAR2(200),
    idAtleta INTEGER NOT NULL,
    PRIMARY KEY(idMicrociclo),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE
);

CREATE TABLE FEEDBACKS(
    idFeedback INTEGER NOT NULL,
    esfuerzo INTEGER CONSTRAINT chkEsfuerzo CHECK(esfuerzo > 0 AND esfuerzo <= 10) NOT NULL,
    observaciones VARCHAR2(300),
    idMicrociclo INTEGER NOT NULL,
    PRIMARY KEY(idFeedback),
    FOREIGN KEY(idMicrociclo) REFERENCES MICROCICLOS ON DELETE CASCADE
);

CREATE TABLE MEDIA(
    idMedia INTEGER NOT NULL,
    descripcion VARCHAR2(500),
    rutafichero VARCHAR2(300) NOT NULL,
    idFeedback INTEGER NOT NULL,
    PRIMARY KEY(idMedia),
    FOREIGN KEY(idFeedback) REFERENCES FEEDBACKS ON DELETE CASCADE
);

CREATE TABLE EJERCICIOS(
    idEjercicio INTEGER NOT NULL,
    titulo VARCHAR2(30),
    descripcion VARCHAR2(500) NOT NULL,
    tipo VARCHAR2(40) NOT NULL,
    PRIMARY KEY(idEjercicio)
);

CREATE TABLE ESPECIFICACIONES(
    idEspecificacion INTEGER NOT NULL,
    repeticiones INTEGER,
    distancia NUMBER(8,2),
    idEjercicio INTEGER NOT NULL,
    idMicrociclo INTEGER NOT NULL,
    PRIMARY KEY(idEspecificacion),
    FOREIGN KEY(idEjercicio) REFERENCES EJERCICIOS ON DELETE CASCADE,
    FOREIGN KEY(idMicrociclo) REFERENCES MICROCICLOS ON DELETE CASCADE
);

CREATE TABLE COMPETICIONES(
    idCompeticion INTEGER NOT NULL,
    lugar VARCHAR2(150) NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    fecha DATE NOT NULL,
    tipo VARCHAR2(30) CONSTRAINT chkTipoC CHECK(tipo IN('Popular','Federado','Benefica')) NOT NULL,
    alcance VARCHAR2(30) CONSTRAINT chkAlcance CHECK(alcance IN('Nacional','Internacional','Regional')) NOT NULL ,
    PRIMARY KEY(idCompeticion)
);

CREATE TABLE PAGOS(
    idPago INTEGER NOT NULL,
    fecha DATE NOT NULL,
    idAtleta INTEGER NOT NULL,
    PRIMARY KEY(idPago),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE
);

CREATE TABLE REUNIONES(
    idReunion INTEGER NOT NULL,
    Fecha DATE NOT NULL,
    Lugar VARCHAR2(80) NOT NULL,
    Duracion VARCHAR2(50),
    PRIMARY KEY(idReunion)
);

CREATE TABLE PRUEBAS(
    idPrueba INTEGER NOT NULL,
    Tipo VARCHAR(50),
    Fecha DATE DEFAULT SYSDATE,
    idAtleta INTEGER NOT NULL,
    PRIMARY KEY(idPrueba),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE    
);

CREATE TABLE DOCUMENTOS(
    idDocumento INTEGER NOT NULL,
    descripcion VARCHAR2(560) NOT NULL,
    rutaFichero VARCHAR2(200) NOT NULL,
    idPago INTEGER,
    idPrueba INTEGER,
    PRIMARY KEY(idDocumento),
    FOREIGN KEY(idPago) REFERENCES PAGOS ON DELETE CASCADE,
    FOREIGN KEY(idPrueba) REFERENCES PRUEBAS ON DELETE CASCADE
);

CREATE TABLE DIETAS(
    idDieta INTEGER NOT NULL,
    Descripcion VARCHAR2(1500) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    idAtleta INTEGER NOT NULL,
    PRIMARY KEY(idDieta),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE
);

CREATE TABLE CONSULTAS(
    idConsulta INTEGER NOT NULL,
    Fecha DATE DEFAULT sysdate NOT NULL,
    Tipo VARCHAR2(50) CONSTRAINT CONSULTAS_CHECK CHECK(Tipo IN('Medica','Dietetica','Otro')) NOT NULL,
    Tema VARCHAR2(40),
    Descripcion VARCHAR2(560) NOT NULL,
    Respuesta VARCHAR2(560),
    idAtleta INTEGER NOT NULL,
    PRIMARY KEY(idConsulta),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE       
);

CREATE TABLE ASISTENCIAS(
    idAsistencia INTEGER NOT NULL,
    idAtleta INTEGER NOT NULL,
    idReunion INTEGER NOT NULL,
    PRIMARY KEY(idAsistencia),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE,
    FOREIGN KEY(idReunion) REFERENCES REUNIONES ON DELETE CASCADE
);

CREATE TABLE RESULTADOS(
    idResultado INTEGER NOT NULL,
    idAtleta INTEGER NOT NULL,
    idCompeticion INTEGER NOT NULL,
    prueba VARCHAR2(50) NOT NULL,
    marca VARCHAR2(25), 
    posicion INTEGER,
    PRIMARY KEY(idResultado),
    FOREIGN KEY(idAtleta) REFERENCES ATLETAS ON DELETE CASCADE,
    FOREIGN KEY(idCompeticion) REFERENCES COMPETICIONES ON DELETE CASCADE
);
