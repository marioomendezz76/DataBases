CREATE LOGIN cRiaza WITH PASSWORD = '1234Aaaa'
CREATE LOGIN jFado WITH PASSWORD = '1234Aaaa'

CREATE DATABASE testDCL_db;
CREATE TABLE test(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nom VARCHAR(20)
);
CREATE TABLE test2(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nom VARCHAR(20)
);

INSERT INTO test(nom) VALUES ('Maria'),('David'),('Andreu');
INSERT INTO test2(nom) VALUES ('Maria'),('David'),('Andreu');

USE testDCL_db;
CREATE USER cRiaza FOR LOGIN cRiaza
GRANT SELECT ON test TO cRiaza
GRANT INSERT, UPDATE ON test TO cRiaza

CREATE USER jFado FOR LOGIN jFado
GRANT SELECT ON test TO jFado

SELECT * FROM Test;
UPDATE test SET nom = 'Alfred' WHERE id=1

UPDATE test SET nom = 'David' WHERE id=2
