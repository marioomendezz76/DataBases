
/********************************************************/
/*				EXERCICI B�SIC					*/
/********************************************************/

-- Suponemos las tablas ya estan creadas.

CREATE DATABASE DCL_Exercici2_DB;
USE DCL_Exercici2_DB;

CREATE TABLE Treballador(
	DNI CHAR(9) PRIMARY KEY,
	nom VARCHAR(20),
	cognoms VARCHAR(40),
	direccio VARCHAR(40),
	email VARCHAR(50),
	salari money,
);
CREATE TABLE Client(
	DNI CHAR(9) PRIMARY KEY,
	nom VARCHAR(20),
	cognoms VARCHAR(40),
	direccio VARCHAR(40),
	email VARCHAR(50),
);

CREATE TABLE Factura(
	codi INT PRIMARY KEY,
	dataF	DATE NOT NULL,
	clientDNI char(9),
	producte	VARCHAR(20),
	import MONEY,
	CONSTRAINT fk_factura_client FOREIGN KEY (clientDNI) REFERENCES Client(DNI)
		ON UPDATE CASCADE ON DELETE NO ACTION
);


INSERT INTO Treballador VALUES ('DNI1','Ruben',' Castro','Av. Tarragona 45','mgonzalez@gmail.com',1200),
		('DNI2','Marcos', 'Garcia','Navarra 12','dhernandez@gmail.com',1700),
		('DNI3','Nuria', 'Fern�ndez','Paseo Mayor 15','pperez@gmail.com',1100),
		('DNI4','David', 'Gonz�lez','Princesa 124','rortega@gmail.com',1450);

INSERT INTO Client VALUES ('DNI1','Juaquin', 'Fern�ndez','Plaza libertad 10','jfernandez@gmail.com'),
		('DNI2','Ignacio', 'De la Fuente','Brasil sur 12','idelafuente@gmail.com'),
		('DNI3','Teresa', 'Flores','Guayaquil 23','tflores@gmail.com'),
		('DNI4','Marcos', 'Vazquez','Campo de Moras 34','mvazquez@gmail.com');

INSERT INTO Factura VALUES (1,'2020-11-15','DNI1','Teclado Logitech',29.95), (2,'2020-11-15','DNI1','Iphone XI',999.95),
				(3,'2020-11-15','DNI2','Tostadora',59.95), (4,'2020-11-15','DNI2','Procesador I9',49.95),
				(5,'2020-11-16','DNI3','TV Samsung 40',129.95),(6,'2020-11-15','DNI3','Kit de limpieza',59.95),
				(7,'2020-11-14','DNI4','Taza de caf�',9.95),(8,'2020-11-16','DNI4','Mando a distancia',29.95),
				(9,'2020-11-11','DNI3','Altavoces 7.1',60.00),(10,'2020-11-11','DNI3','Aspirador 30W',129.95);

CREATE LOGIN rCastro WITH PASSWORD = '1234' MUST_CHANGE,
    CHECK_POLICY=ON, CHECK_EXPIRATION = ON;
CREATE LOGIN mgarcia WITH PASSWORD = '1234' MUST_CHANGE,
    CHECK_POLICY=ON, CHECK_EXPIRATION = ON;
CREATE LOGIN nFernandez WITH PASSWORD = '1234' MUST_CHANGE,
    CHECK_POLICY=ON, CHECK_EXPIRATION = ON;
CREATE LOGIN dGonzalez WITH PASSWORD = '1234' MUST_CHANGE,
    CHECK_POLICY=ON, CHECK_EXPIRATION = ON;
CREATE LOGIN xGarcia WITH PASSWORD = '1234' MUST_CHANGE,
    CHECK_POLICY=ON, CHECK_EXPIRATION = ON;
CREATE LOGIN sJimenez WITH PASSWORD = '1234' MUST_CHANGE,
    CHECK_POLICY=ON, CHECK_EXPIRATION = ON;


USE DCL_Exercici2_DB;
CREATE USER rCastro FOR LOGIN rCastro;
CREATE USER mGarcia FOR LOGIN mGarcia;
CREATE USER nFernandez FOR LOGIN nFernandez;
CREATE USER dGonzalez FOR LOGIN dGonzalez;
CREATE USER xGarcia FOR LOGIN xGarcia;
CREATE USER sJimenez FOR LOGIN sJimenez;

--Crear ROLS:
CREATE ROLE Seguretat;
CREATE ROLE Informatica;
CREATE ROLE RRHH;
CREATE ROLE Comptabilitat;

--Afegir Membres al Rol:
ALTER ROLE Seguretat ADD MEMBER rCastro;
ALTER ROLE Informatica ADD MEMBER mGarcia;
ALTER ROLE Informatica ADD MEMBER nfernandez;
ALTER ROLE RRHH ADD MEMBER dGonzalez;
ALTER ROLE RRHH ADD MEMBER xGarcia;
ALTER ROLE Comptabilitat ADD MEMBER sJimenez;

--Otorgar permisos als rols:
ALTER ROLE db_securityadmin ADD MEMBER Seguretat;
ALTER ROLE db_accessadmin ADD MEMBER Seguretat;

ALTER ROLE setupadmin ADD MEMBER Informatica;
--Permiso de select, update y delete sobre treballador a los RRHHH
GRANT SELECT, UPDATE, DELETE ON Treballador TO RRHH;
DENY SELECT ON Client TO RRHH;
DENY SELECT ON Factura TO RRHH;

GRANT SELECT, DELETE, UPDATE ON Factura TO Comptabilitat;
GRANT SELECT ON Client(DNI, nom, email) TO Comptabilitat;
DENY UPDATE, DELETE ON Client TO Comptabilitat;

SELECT DNI, nom, email FROM Client


/*
Que niveles de acceso tiene sqlserver?
ACCESO A SERVIDOR
ACCESO A BASE DE DATOS
ACCESO A OBJETOS
*/
