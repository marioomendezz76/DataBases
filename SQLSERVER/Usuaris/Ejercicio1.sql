

/********************************************************/
/*				EXERCICI B�SIC					*/
/********************************************************/

-- Suponemos las tablas ya estan creadas.

CREATE DATABASE DCL_Exercici1_DB;
USE DCL_Exercici1_DB;

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

CREATE LOGIN mFernandez WITH PASSWORD='Educem123' MUST_CHANGE, CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER mFernandez FOR LOGIN mFernandez

CREATE LOGIN aMartinez WITH PASSWORD='Educem123' MUST_CHANGE, CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER aMartinez FOR LOGIN aMartinez

CREATE LOGIN mRodriguez WITH PASSWORD='Educem123' MUST_CHANGE, CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER mRodriguez FOR LOGIN mRodriguez

CREATE LOGIN dPorti WITH PASSWORD='Educem123' MUST_CHANGE, CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER dPorti FOR LOGIN dPorti

CREATE LOGIN cRiaza WITH PASSWORD='Educem123' MUST_CHANGE, CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER cRiaza FOR LOGIN cRiaza