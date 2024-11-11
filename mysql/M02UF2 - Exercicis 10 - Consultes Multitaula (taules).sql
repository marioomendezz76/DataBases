create database ddl_ex10ConsultesMultitaules;
use ddl_ex10ConsultesMultitaules;

CREATE TABLE IF NOT EXISTS Clients
(
	DNI CHAR(9),
    nom	varchar(20),
    poblacio varchar(20),
    provincia varchar(20) DEFAULT 'Barcelona',
	dataNaix DATE,
     PRIMARY KEY (dni)
);

CREATE TABLE IF NOT EXISTS Article
(
    codi	char(11),
    nom	varchar(20),
    preu decimal(8,2),
    familia varchar(30) NOT NULL,
     PRIMARY KEY (codi),
	CONSTRAINT verifPreu CHECK (preu>=0 AND preu<=30000)
);

CREATE TABLE IF NOT EXISTS Factura
(
	codi		char(9),
    dataFac		date,
	clientDNI	char(9),
	 PRIMARY KEY (codi),
	CONSTRAINT fk_clients_factura	FOREIGN KEY (clientDNI) REFERENCES clients (DNI)
		ON UPDATE CASCADE ON DELETE RESTRICT

);

CREATE TABLE IF NOT EXISTS Liniafactura
(
	facturacodi	CHAR(9),
	articlecodi	CHAR(11),
    qtt	tinyint,
    
     PRIMARY KEY (facturacodi,articlecodi),
    
    CONSTRAINT fk_factura_Liniafactura
		FOREIGN KEY (facturacodi) REFERENCES Factura (codi)
			ON UPDATE RESTRICT ON DELETE RESTRICT,
	
    CONSTRAINT fk_article_Liniafactura FOREIGN KEY (articlecodi) REFERENCES Article (codi)
		ON UPDATE RESTRICT ON DELETE RESTRICT

);

INSERT INTO Clients VALUES 	('11111111A','Joan Garcia','Mollet','Barcelona', '2001-01-20');
INSERT INTO Clients VALUES 	('22222222B','Maria Maldonado','Granollers','Barcelona','2001-01-12');
INSERT INTO Clients VALUES 	('33333333C','Carles Jiménez','Granollers','Barcelona','2001-02-20');
INSERT INTO Clients VALUES 	('44444444D','Ramon Sanchez','Girona','Girona','2001-06-20');
INSERT INTO Clients VALUES 	('55555555E','Pere Hinojosa','Girona','Girona','2002-02-23'); 
INSERT INTO Clients VALUES 	('66666666F','Blas Garcia','Valencia','Girona','2000-01-20');
                            
INSERT INTO Article VALUES 	('Z88', 'Oso de Mesa', 567.0, 'Sobretaula/Mantel'),
							('A01','Ratolí',16,'Perifèric/Ratolí'), 
							('A33','Impressora HP',100.84,'Perifèric/Impressora'), 
                            ('A56','Portátil Asus',500.95,'Portàtil/Portàtil'), 
                            ('B32','NVIDIA 1070',354,'Component/Grafica'), 
                            ('G56','Intel I3 6071',164,'Component/Processador'), 
                            ('G57','Intel I5 7091',264,'Component/Processador'), 
                            ('G58','Intel I7 7071',344,'Component/Processador'), 
                            ('D34','RAM 8GB DDR4',46.90,'Component/RAM'),
                            ('S12','RAM 16GB DDR4',84.95,'Component/RAM'),
                            ('J34','Font 500W',46.90,'Component/Font'),
                            ('D32','Font 750W',76.90,'Component/Font'),
                            ('D39','Placa Gigabyte P45',46.90,'Component/PlacaBase'),
                            ('F34','Placa Asus Rock A566',96.40,'Component/PlacaBase'),
                            ('O34','Torre SOE ATX Gaming',46.90,'Component/Torre'),
                            ('Z34','Phoenix ATX 67',76.90,'Component/Torre'),
                            ('Z35','Phoenix ATX 67',36.90,'Component/Torre'),
                            ('Z44','Asus Gaming 23p',156.90,'Pantalla/Monitor'),
                            ('Z54','LG Pro 21p',142.50,'Pantalla/Monitor'),
                            ('Z64','Teclat Logitech G120',45.90,'Periféric/Teclat'),
                            ('Z74','Teclat Logitech K70',86.90,'Periféric/Teclat');
                            
INSERT INTO Factura VALUES	('006746/20','2016-02-05','11111111A'), 
							('000001/20','2016-12-05','11111111A'), 
                            ('000002/21','2018-10-05','33333333C'), 
                            ('000003/21','2018-11-05','22222222B'), 
                            ('000004/19','2019-07-05','44444444D'),
                            ('000005/21','2018-01-01','33333333C');                             
INSERT INTO Liniafactura VALUES 
							('006746/20','Z54',10),('006746/20','Z35',5),
							('000001/20','Z35',2),('000001/20','F34',5),
							('000002/21','Z54',3),('000002/21','Z44',5),
							('000003/21','Z74',3),
							('000004/19','D39',3),('000004/19','F34',3),
                            ('000005/21','D39',2),('000005/21','Z64',3);


-- **************************** CONSULTES **********************************
/*1. Obtenir quantes factures hi ha hagut per província i per població. En cas que hi hagin províncies
que no hagin tingut factures, cal que es mostri un 0.*/
SELECT COUNT(F.codi) AS qttFactures, C.poblacio, C.provincia
	FROM Clients C LEFT JOIN Factura F ON C.DNI = F.clientDNI
	GROUP BY C.provincia, C.poblacio;

/*2. Obtenir el numero total de factures que té cada client amb el DNI i una altra columna amb el
Nom i Cognom*/
SELECT COUNT(F.codi) AS NumeroFactures, C.DNI, C.nom
	FROM Factura F JOIN Clients C ON F.clientDNI = C.DNI
    GROUP BY C.DNI;
-- 3. Obtenir el numero total de factures per a tots els clients que viuen a Barcelona.
SELECT COUNT(F.codi) AS qttFactures, C.nom
	FROM Factura F RIGHT JOIN Clients C ON F.clientDNI = C.DNI
    WHERE c.Provincia='Barcelona'
    GROUP BY C.nom;
-- 4. Obtenir el numero total de factures trameses en cada una de les ciutats de província catalanes.
SELECT COUNT(F.codi) AS qttFactures, C.Provincia
	FROM Clients C LEFT JOIN  Factura F ON C.DNI = F.clientDNI
    GROUP BY C.Provincia;
/*5. Realitzar un llistat de tots els articles de la família «sobretaula» que el seu nom comenci per la
lletra «o» amb un preu unitari superior a 400€.*/
SELECT nom, familia, preu FROM Article
	WHERE familia LIKE 'sobretaula%' AND nom LIKE 'o%' AND preu > 400;
/*6. Obtenir el nom dels articles que són més cars que els articles de les famílies
Component/Processador*/
SELECT nom, familia, preu FROM Article
	WHERE preu >  (SELECT AVG(preu) FROM article WHERE familia='Component/Processador') AND familia<>'Component/Processador';
/*7. Obtenir el codi de l'article, el nom de l'article i la quantitat comprada per a cada una de les línies
de factura.*/
SELECT A.codi, A.nom, COUNT(A.codi) AS qttComprada, L.facturaCodi
	FROM Article A JOIN LiniaFactura L ON A.codi = L.articleCodi
    GROUP BY L.facturaCodi, A.codi;
-- 8. Obtenir l'import total facturat amb totes les factures
SELECT SUM(A.preu) AS importTotal, L.facturaCodi
	FROM Article A JOIN Liniafactura L oN A.codi = L.articleCodi
    GROUP BY L.facturaCodi;
-- 9. Obtenir l'import facturat per a cada una de les famílies d'articles.
/*10. Obtenir la informació de tots els articles i la seva quantitat venuda. Obtindrem el valor NULL o
0 (zero) en el cas que el producte no hagi tingut cap venda.*/
-- 11. Obtenir l'import total de la factura 006746/15.
/*12. Obtenir l'import facturat per a cada un dels clients que siguin de la ciutat de Girona. Cal ordenar
el resultat de major a menor import.*/
/*13. Obtenir el codi i la data de totes les factures amb un import superior al de la factura 000004/19.
productes adquirits.*/
/*15. Obtenir el total facturat per mes durant l'any 2018 i 2021. Ordenar el resultat per any i mes de
forma descendent l’import.*/
/*16. Obtenir quines factures tenen una facturació major a l'import mitjà de la facturació de la
població de «Granollers».*/
-- 17. Obtenir tots els articles dels quals no s'hagi venut cap unitat.
/*18. Obtenir el dni i el nom de tots els clients que no tinguin cap factura excepte els que son de la
província Barcelona.*/
-- 19. Digues el DNI i el nom del client que ha fet la factura més cara.
/*20. Mostra els nom dels clients que han comprat més articles que en la suma del total d’articles que
han comprat els clients amb cognom Garcia.*/
/*21. A partir d’ara es vol tenir el control de la categoria el qual pertany un article. De la categoria es
vol emmagatzemar, el nom de la categoria, si aquesta categoria té data de caducitat i el tipus de
risc que va entre 1 y 10 (per defecte és 5). Realitza les instruccions necessàries per tal de poder
resoldre aquest nou requeriment.*/