-- **************************************************
--                      AmaCem
-- **************************************************
CREATE TABLE Usuari(
    idUsuari INT PRIMARY KEY,
    nom VARCHAR2(40),
    cognom VARCHAR2(40),
    email VARCHAR2(50)
);
CREATE OR REPLACE TYPE 
