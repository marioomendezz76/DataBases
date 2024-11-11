-- **************************************************
--                      AmaCem
-- **************************************************
DROP TYPE T_Telefon FORCE;

CREATE OR REPLACE TYPE T_Telefon AS OBJECT(
    principal CHAR(9),
    secundari CHAR(9)
);


CREATE TABLE Usuari(
    idUsuari INT PRIMARY KEY,
    nom VARCHAR2(20) NOT NULL,
    cognom VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    telefon T_Telefon
);

CREATE OR REPLACE TYPE T_Preu AS OBJECT(
    preuBase NUMBER(6,2),
    valorIVA INT
);

CREATE OR REPLACE TYPE T_Dimensio AS OBJECT(
    llarg INT,
    ample INT,
    alt INT
);
CREATE OR REPLACE TYPE T_Paquet AS OBJECT(
    pes NUMBER(6,2),
    bultos INT,
    dimensions T_Dimensio,
    MEMBER FUNCTION preuBaseEnviament RETURN NUMBER,
    MEMBER FUNCTION pesMigBultos RETURN NUMBER,
    MEMBER PROCEDURE mostrarInfo
);

CREATE OR REPLACE TYPE BODY T_Paquet AS
    MEMBER FUNCTION preuBaseEnviament RETURN NUMBER AS
    BEGIN
        RETURN (dimensions.llarg * dimensions.ample * dimensions.alt) / 10 * pes * bultos/150;
    END;
    MEMBER FUNCTION pesMigBultos RETURN NUMBER AS
    BEGIN
        RETURN pes/bultos;
    END;
    MEMBER PROCEDURE mostrarInfo AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Pes: '|| pes);
        DBMS_OUTPUT.PUT_LINE('Bultos: '|| bultos);
        DBMS_OUTPUT.PUT_LINE('Llargada: '|| dimensions.llarg);
        DBMS_OUTPUT.PUT_LINE('Amplada: '|| dimensions.ample);
        DBMS_OUTPUT.PUT_LINE('Al�ada: '|| dimensions.alt);
    END;
END;


CREATE TABLE Producte(
    codi CHAR(8) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    preu T_Preu,
    paquet T_paquet
);

CREATE TABLE Enviament(
    usuariID INT,
    producteCodi CHAR(8),
    distancia INT,
    urgencia INT,
    CONSTRAINT verifUrgencia CHECK (urgencia BETWEEN 1 AND 3),
    CONSTRAINT fk_enviament_usuari FOREIGN KEY(usuariID) REFERENCES Usuari(idUsuari),
    CONSTRAINT fk_enviament_producte FOREIGN KEY(producteCodi) REFERENCES Producte(codi)
);
/*1. Crea les taules corresponents CLIENT i PRODUCTE amb els tipus predefinits
corresponents.*/
/*2. Inserta 2 clients i 2 productes.*/
INSERT INTO Usuari VALUES (1, 'Maria', 'De la O', 'maria.delao@gmail.com', T_Telefon('666112233', '666445566'));
INSERT INTO Usuari VALUES (2, 'Jose', 'Martinez', 'jose.martinez@gmail.com', T_Telefon('666778899', '666001122'));

INSERT INTO Producte VALUES ('PROD0001', 'Teclat Logitech MK150', T_Preu(99.95, 21), T_Paquet(1.6, 1, T_Dimensio(100, 30, 10)));
INSERT INTO Producte VALUES ('PROD0002', 'Tablet', T_Preu(200.00, 21), T_Paquet(0.50, 1, T_Dimensio(35, 20, 10)));

INSERT INTO Enviament VALUES('COD00001','PROD0001',200,3);
INSERT INTO Enviament VALUES('COD00001','PROD0001',200,3);
INSERT INTO Enviament VALUES('COD00001','PROD0001',200,3);

/*3. Crea l’objecte PAQUET amb els seus atributs i mètodes (a continuació) amb el seu
BODY corresponent.
Cal desenvolupar en el paquet els següents mètodes:
• Funció preuBaseEnviament: Cal que retorni el preu base per enviar el producte.
La fórmula es la següent: (llarg x ample x alt) / 10 * pes * bultos/150
• Funció pesMigBultos: Cal que retorni el preu mig del total de bultos.
• Procediment mostrar informació: Cal mostrar totes les dades de paquet.*/
CREATE OR REPLACE TYPE T_Dimensio AS OBJECT(
    llarg INT,
    ample INT,
    alt INT
);

CREATE OR REPLACE TYPE T_Paquet AS OBJECT(
    pes NUMBER(6,2),
    bultos INT,
    dimensions T_Dimensio,
    MEMBER FUNCTION preuBaseEnviament RETURN NUMBER,
    MEMBER FUNCTION pesMigBultos RETURN NUMBER,
    MEMBER PROCEDURE mostrarInfo
);

CREATE OR REPLACE TYPE BODY T_Paquet AS
    MEMBER FUNCTION preuBaseEnviament RETURN NUMBER AS
    BEGIN
        RETURN (dimensions.llarg * dimensions.ample * dimensions.alt) / 10 * pes * bultos / 150;
    END;
    MEMBER FUNCTION pesMigBultos RETURN NUMBER AS
    BEGIN
        RETURN pes / bultos;
    END;
    MEMBER PROCEDURE mostrarInfo AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Pes: ' || pes);
        DBMS_OUTPUT.PUT_LINE('Bultos: ' || bultos);
        DBMS_OUTPUT.PUT_LINE('Llargada: ' || dimensions.llarg);
        DBMS_OUTPUT.PUT_LINE('Amplada: ' || dimensions.ample);
        DBMS_OUTPUT.PUT_LINE('Alçada: ' || dimensions.alt);
    END;
END;


/*EXERCICI 4: Inserta les dades de dos productes.  */

INSERT INTO Producte VALUES ('PROD0001','Teclat Logitech MK150',T_Preu(99.95,21),
        T_Paquet(1.6,1,T_Dimensio(100,30,10)));
INSERT INTO Producte VALUES('PROD0002','Tablet',T_preu(200.00,21),T_paquet(0.50,1,T_dimensio(35,20,10)));
INSERT INTO Producte VALUES('PROD0003','Port�til ASUS',T_preu(700.00,21),T_paquet(1.5,1,T_dimensio(50,35,15)));

/*EXERCICI 5: Mostra el cost d'enviament base de tots els productes inserits. .  */

SELECT codi, nom, ROUND(P.paquet.preuBaseEnviament(),2) AS PreuEnviament FROM Producte P;

/*EXERCICI 6: Mostra el cost d'enviament sabent que el costFinal d'enviament es calcula amb:*/

INSERT INTO Usuari VALUES(1,'Maria','De la O','maria.delao@gmail.com',T_telefon('666112233','666445566'));
INSERT INTO Usuari VALUES(2,'Jose','Martinez','jose.martinez@gmail.com',T_telefon('666778899','666001122'));

INSERT INTO Enviament VALUES (1,'PROD0001',300,3);
INSERT INTO Enviament VALUES (1,'PROD0002',200,2);
INSERT INTO Enviament VALUES (2,'PROD0003',350,1);
INSERT INTO Enviament VALUES (2,'PROD0001',400,3);


SELECT P.codi, P.nom, ROUND(P.paquet.preuBaseEnviament()*0.1*E.distancia*E.urgencia,2) AS CostFinal FROM Producte P
    INNER JOIN Enviament E ON P.codi = E.producteCodi;