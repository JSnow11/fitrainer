 /*Codigo para introducir una poblacion de datos a la base de datos para comprobar su correcto funcionamiento  */
/*ATLETAS*/
exec nuevo_atleta('Juan', 'Montero Quimera', 35, 'M', 623844322, 'Avenida de la Paz',  'Lesionado', 'jmq@gmail.com', '123qweASD', 1);
exec nuevo_atleta('Rafael', 'Lopez Erguido', 19, 'M', 849392123, 'Avenida de la Palmera',  'Buena forma', 'rafapoon@gmail.com', '1238fdj3j4fF', 1);
exec nuevo_atleta('Juan', 'Gomez Pontiga', 19, 'M', 353844442, 'Avenida de la Paz',  'Alto rendimiento', 'juaniot@gmail.com', '12312qwefsa3r123D', 1);
exec nuevo_atleta('Rodrigo', 'Alonso Olgado', 34, 'M', 847388293, 'Avenida de la Farola',  'Buena forma', 'rodri@gmail.com', '123QWEasd', 1);
exec nuevo_atleta('Luis', 'Nunez Pontiga', 39, 'M', 622222342, 'Avenida de la Esquina',  'Lesionado', 'pedon@gmail.com', '123qweT312sd4', 1);
exec nuevo_atleta('Pedro', 'Ramirez Gonzalez', 45, 'M', 898374323, 'Avenida de la Paz',  'Buena forma', 'prg@gmail.com', '123qweASD', 1);
exec nuevo_atleta('Juan', 'Lopez Argudo', 35, 'M', 623844322, 'Avenida de la Inspiracion',  'Baja forma', 'jla@gmail.com', '123qweASD', 1);

/*PAGOS*/
exec introducir_pago(to_date('02/09/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('01/10/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('01/11/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('01/12/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('03/12/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('04/01/20', 'DD/MM/YY'),4);
exec introducir_pago(to_date('01/02/20', 'DD/MM/YY'),4);
exec introducir_pago(to_date('04/03/20', 'DD/MM/YY'),4);
exec introducir_pago(to_date('04/04/20', 'DD/MM/YY'),4);
exec introducir_pago(to_date('04/05/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('03/03/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('05/02/19', 'DD/MM/YY'),4);
exec introducir_pago(to_date('04/07/19', 'DD/MM/YY'),4);

/*MICROCICLOS*/
exec introducir_microciclo('Lesionado', null,to_date('09/12/19', 'DD/MM/YY'),null, 1);
exec introducir_microciclo('Buena forma',null, to_date('09/12/19', 'DD/MM/YY'),null, 2);
exec introducir_microciclo('Alto rendimiento',null, to_date('09/12/19', 'DD/MM/YY'),null, 3);
exec introducir_microciclo('Buena forma','Realiza los ejercicios cada 2 dias', to_date('09/12/19', 'DD/MM/YY'),'Crioterapia', 4);
exec introducir_microciclo('Buena forma','Realiza los ejercicios Lunes, Miercoles y Viernes', to_date('01/01/20', 'DD/MM/YY'),'Crioterapia', 4);
exec introducir_microciclo('Buena forma','Tomatelo con calma, realiza las repeticiones con tranquilidad', to_date('8/01/20', 'DD/MM/YY'),'Trata de descansar bien, recupera carbohidratos y reposa la rodilla', 4);
exec introducir_microciclo('Buena forma','Realiza cada dia', to_date('15/01/20', 'DD/MM/YY'),'Crioterapia', 4);
exec introducir_microciclo('Buena forma','Realiza los ejercicios todos los dias', to_date('22/01/20', 'DD/MM/YY'),'Estira bien las piernas y masajea cualquier zona con dolor', 4);
exec introducir_microciclo('Buena forma','Realiza los ejercicios Martes, Jueves y Domingo, aprieta y trata de seguir buenas pautas', sysdate,'Crioterapia', 4);


/*CONSULTA*/
exec nueva_consulta('Medica',null,'Consulta sobre x asunto',1);
exec nueva_consulta('Dietetica',null,'Consulta sobre x asunto',2);
exec nueva_consulta('Dietetica',null,'Consulta sobre x asunto',1);
exec nueva_consulta('Otro',null,'Consulta sobre x asunto',2);
INSERT INTO CONSULTAS(Fecha, Tipo,Tema,Descripcion,Respuesta,idAtleta) VALUES(to_date('15/01/20', 'DD/MM/YY') ,'Medica','Dolores agudos en la rodilla', 'Me duele levemente pero de forma constante','Ten cuidado con la pisada al correr', 4);
INSERT INTO CONSULTAS(Fecha, Tipo,Tema,Descripcion,Respuesta,idAtleta) VALUES(to_date('11/03/20', 'DD/MM/YY') ,'Dietetica','Me quedo con hambre', 'La dieta actual me deja con hambre tras las comidas','Trata de suplir esa hambre con carbohidratos y vegetales', 4);
INSERT INTO CONSULTAS(Fecha, Tipo,Tema,Descripcion,Respuesta,idAtleta) VALUES(to_date('14/02/20', 'DD/MM/YY') ,'Medica','Dolores fuertes en la rodilla', 'Me duele mucho y de forma constante','Ten cuidado con la pisada al correr, empezaremos a usar tecnicas de tratamiento la semana que viene', 4);
exec nueva_consulta('Dietetica','Duda de dieta','¿Puedo comer hamburguesas?',4);
exec nueva_consulta('Medica','Duda sobre mi dolor de espalda','Noto punzadas muy dolorosas',4);
exec nueva_consulta('Otro','Ultima competicion','Me quedo con dudas sobre como afrontar la proxima competicion',4);



/*COMPETICIONES*/
exec nueva_competicion('Puente Genil','Carrera de Navidad',TO_DATE('25/12/19'),'Benefica','Regional');
exec nueva_competicion('Sevilla','Maraton de Navidad',TO_DATE('28/12/19'),'Popular','Regional');
exec nueva_competicion('Madrid','Carrera de Anno Nuevo',TO_DATE('01/01/20'),'Benefica','Nacional');
exec nueva_competicion('Cordoba','La Gran Maraton',TO_DATE('06/01/20'),'Federado','Internacional');
exec nueva_competicion('Cadiz','Carrera de Carnaval',TO_DATE('10/01/20'),'Popular','Nacional');

exec nueva_competicion('Puente Genil','Carrera Olimpica',TO_DATE('25/12/20'),'Benefica','Regional');
exec nueva_competicion('Sevilla','Fiesta del atletismo',TO_DATE('28/09/20'),'Popular','Regional');
exec nueva_competicion('Madrid','5a carrera solidaria por el medio ambiente',TO_DATE('23/06/20'),'Benefica','Nacional');
exec nueva_competicion('Cordoba','Maraton 2020',TO_DATE('06/11/20'),'Federado','Internacional');
exec nueva_competicion('Cadiz','Trail Running Competition',TO_DATE('10/10/20'),'Popular','Nacional');

/*RESULTADOS*/
exec nuevo_resultado(1,1,'100 ml','10.4', 1);
exec nuevo_resultado(1,2,'200 ml','20.3', 1);
exec nuevo_resultado(2,1,'3000 ml','15:02', 4);
exec nuevo_resultado(3,2,'Media Maraton','01:03:12', 2);
exec nuevo_resultado(4,3,'30 km','01:30:44', 1);
exec nuevo_resultado(4,4,'Maraton','02:20:44', 5);
exec nuevo_resultado(4,1,'Milla','3:44', 1);
exec nuevo_resultado(4,2,'Maraton','02:10:44', 2);

exec nuevo_resultado(4,6,'100 ml',null, null);
exec nuevo_resultado(4,7,'200 ml',null, null);
exec nuevo_resultado(4,8,'3000 ml',null, null);
exec nuevo_resultado(4,9,'Maraton',null, null);
exec nuevo_resultado(4,10,'200 ml',null, null);

exec nuevo_resultado(5,6,'100 ml',null, null);
exec nuevo_resultado(5,7,'200 ml',null, null);
exec nuevo_resultado(5,8,'3000 ml',null, null);
exec nuevo_resultado(5,9,'100 ml',null, null);
exec nuevo_resultado(5,10,'200 ml',null, null);

exec nuevo_resultado(3,6,'100 ml',null, null);
exec nuevo_resultado(3,7,'200 ml',null, null);
exec nuevo_resultado(2,8,'3000 ml',null, null);
exec nuevo_resultado(1,9,'100 ml',null, null);
exec nuevo_resultado(3,10,'200 ml',null, null);

exec nuevo_resultado(6,6,'100 ml',null, null);
exec nuevo_resultado(7,7,'200 ml',null, null);
exec nuevo_resultado(6,8,'3000 ml',null, null);
exec nuevo_resultado(7,9,'100 ml',null, null);
exec nuevo_resultado(6,10,'200 ml',null, null);

/*FEEDBACKS*/
exec introducir_feedback(8,'Me ha ido muy bien, he mejorado mi velocidad',1);
exec introducir_feedback(7,'Me ha ido muy bien, pero se me han roto las mancuernas',2);
exec introducir_feedback(5,'Me gustaria que mis abdominales fueran mas musculusos',3);
exec introducir_feedback(8,'Noto que mi pierna ha mejorado',4);
exec introducir_feedback(8,'Noto que he mejorado corriendo',5);
exec introducir_feedback(10,'Noto que he mejorado corriendo',6);
exec introducir_feedback(8,'Noto que he mejorado corriendo',7);
exec introducir_feedback(9,'Noto que he mejorado corriendo',8);
exec introducir_feedback(7,'Ha sido mas duro de lo habitual',9);

/*EJERCICIOS*/
exec introducir_ejercicio('100 metros lisos','Correr 100 metros sobre suelo nivelado','Velocidad/Resistencia');
exec introducir_ejercicio('Pesas','Hacer biceps con las mancuernas','Fuerza/Resistencia');
exec introducir_ejercicio('Abdominales','Hacer abdominales sobre suelo nivelado con o sin peso extra','Resistencia');
exec introducir_ejercicio('Estiramientos','Hacer estiramientos basicos','Recuperacion');
exec introducir_ejercicio('200 metros con obstaculos','Correr 200 metros con obstaculos','Resistencia/Velocidad');
exec introducir_ejercicio('Carrera Continua','Manten ritmo constante','Fondo');
            
/*ESPECIFICACIONES*/
call introducir_ej_a_microciclo(null,10.0,1,1);
call introducir_ej_a_microciclo(5,null,1,4);
call introducir_ej_a_microciclo(3,null,4,4);
call introducir_ej_a_microciclo(1,null,3,5);
call introducir_ej_a_microciclo(1,10.500,6,4);
call introducir_ej_a_microciclo(1,14.0,6,6);
call introducir_ej_a_microciclo(3,null,5,6);
call introducir_ej_a_microciclo(1,10.0,6,8);
call introducir_ej_a_microciclo(1,null,2,8);
call introducir_ej_a_microciclo(2,20.0,6,9);
call introducir_ej_a_microciclo(4,12.5,6,9);
call introducir_ej_a_microciclo(4,null,2,9);
call introducir_ej_a_microciclo(5,null,3,9);

            
/*MEDIA*/
exec introducir_media('Video de los 100 metros','https://www.gogodriva.com//12Q3433242242',1);
exec introducir_media('Foto de las mancuernas','https://www.gogodriva.com//1234322q1242',2);
exec introducir_media('Fotos de mis abdominales','https://www.gogodriva.com//12343223e2qe42',3);
exec introducir_media('Foto de mi pierna lesionada','https://www.gogodriva.com//1234322q3qedsas42',4);

/*DIETAS*/
exec nueva_dieta('Come verduras',TO_DATE('02/02/20'),TO_DATE('01/01/20'),1);
exec nueva_dieta('Bebe mucha agua',null,TO_DATE('01/01/20'),2);
exec nueva_dieta('Come verduras',null,TO_DATE('01/01/20'),3);
exec nueva_dieta('No mezcles los alimentos ricos en proteinas (carne, pescado, leche ... ) con hidratos de carbono (cereales y harinas: pan, pasta, arroz, legumbres: como las lentejas). A excepcion de los huevos. No mezcles grasas ( aceites , frutos secos , mantequilla ... ) con las proteinas. El azucar debe ser sustituido por un edulcorante, o directamente eliminado. Los diferentes tipos de hidratos de carbono no se pueden mezclar entre si (por ejemplo: las verduras y las patatas, no casan bien). Por lo general la fruta no combina bien con otros grupos de alimentos, debe tomarse por separado. Tampoco casan bien diferentes frutas mezcladas entre si ( uvas con naranjas, por ejemplo). Legumbres y hortalizas ( verduras de hoja verde , cebollas , calabacines, zanahorias , esparragos, tomates ... ) generalmente se pueden mezclar con todo, excepto con fruta. Las nueces no deben mezclarse con otros alimentos, especialmente con los que tienen proteinas . Tambien se eliminan los refrescos (excepto si son light) y el alcohol.',TO_DATE('02/02/20'),TO_DATE('01/02/20'),4);
exec nueva_dieta('Lo mas importante para alcanzar la cetosis es evitar comer demasiados carbohidratos. Probablemente tendras que mantener la ingesta de carbohidratos por debajo de 50 gramos por dia de carbohidratos netos, idealmente por debajo de 20 gramos. Cuantos menos carbohidratos se consuma, mas efectivo parece ser para alcanzar la cetosis, perder peso o revertir la diabetes tipo 2',TO_DATE('05/03/20'),TO_DATE('02/02/20'),4);
exec nueva_dieta('Come verduras y pescado, evita alimentos grasos. Bebe mucha agua, es importante que te hidrates. Evita bebidas energeticas y refrescos. No comas snacks.',TO_DATE('04/05/20'),TO_DATE('05/03/20'),4);
exec nueva_dieta('Anade todos los hidratos de carbono que puedas para prepararte para la maraton. Tienes que tomar grandes raciones de pasta y por las noches ensaladas ricas en fibra y fruta.',TO_DATE('30/06/20'),TO_DATE('04/05/20'),4);


/*REUNIONES*/
exec nueva_reunion(TO_DATE('23/02/20'),'Cadiz, Plaza Espana','1 hora');
exec nueva_reunion(TO_DATE('05/03/20'),'Sevilla, Plaza Espana', null);
exec nueva_reunion(TO_DATE('11/04/20'),'Cordoba, Plaza Espana',null);
exec nueva_reunion(TO_DATE('15/05/20'),'Huelva, Plaza Espana','1 hora');
exec nueva_reunion(TO_DATE('20/06/20'),'Granada, Plaza Espana','30 minutos');
exec nueva_reunion(TO_DATE('20/06/20'),'Granada, Plaza Espana','30 minutos');
exec nueva_reunion(TO_DATE('20/09/20'),'Granada, Plaza Espana','30 minutos');
exec nueva_reunion(TO_DATE('20/12/20'),'Sevilla, Plaza Espana','30 minutos');


/*ASISTENCIAS*/
exec nueva_asistencia(1,1);
exec nueva_asistencia(2,1);
exec nueva_asistencia(3,1);
exec nueva_asistencia(4,2);
exec nueva_asistencia(4,3);

/*PRUEBAS*/
exec nueva_prueba('Analitica',TO_DATE('12/10/19'),1);
exec nueva_prueba('Radiografia',sysdate,2);
exec nueva_prueba('ElectroCardiograma',TO_DATE('4/1/18'),3);
exec nueva_prueba('Biopsia',TO_DATE('30/1/19'),4);
exec nueva_prueba('Electro',TO_DATE('22/09/19'),4);
exec nueva_prueba('Biopsia',TO_DATE('12/10/19'),4);
exec nueva_prueba('Biopsia',TO_DATE('20/07/19'),4);
exec nueva_prueba('Biopsia',TO_DATE('20/08/19'),4);
exec nueva_prueba('Biopsia',TO_DATE('03/01/20'),4);
exec nueva_prueba('Analitica',sysdate, 4);
exec nueva_prueba('Ecografia',TO_DATE('28/06/19'),5);

/*DOCUMENTOS*/
exec introducir_documento('Electrocardiograma','http://localhost/FiTrainer/ficheros/pruebas/electro.pdf',null, 5);
exec introducir_documento('Biopsia','http://localhost/FiTrainer/ficheros/pruebas/biopsia.pdf',null, 4);
exec introducir_documento('Biopsia','http://localhost/FiTrainer/ficheros/pruebas/biopsia (2).pdf',null, 6);
exec introducir_documento('Biopsia','http://localhost/FiTrainer/ficheros/pruebas/biopsia (3).pdf',null, 7);
exec introducir_documento('Biopsia','http://localhost/FiTrainer/ficheros/pruebas/biopsia (4).pdf',null, 8);
exec introducir_documento('Biopsia','http://localhost/FiTrainer/ficheros/pruebas/biopsia (5).pdf',null, 9);
exec introducir_documento('Biopsia','http://localhost/FiTrainer/ficheros/pruebas/analitica.pdf',null, 10);

exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago.pdf', 1, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (2).pdf', 2, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (3).pdf', 3, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (4).pdf', 4, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (5).pdf', 5, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (6).pdf', 6, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (7).pdf', 7, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (8).pdf', 8, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (9).pdf', 9, null);
exec introducir_documento('Pago','http://localhost/FiTrainer/ficheros/pagos/pago (10).pdf', 10, null);

