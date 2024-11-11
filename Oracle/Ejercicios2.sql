/*Volem crear una base de dades per a controlar els productes de la nostra fruiteria SEMPRES�.
Cada producte s'identifica per un codi, un nom, un preu i disposa d'uns valors nutritius: calories,
hidrats de carboni i greixos i d�una informaci� per saber la ciutat d�origen, el transport amb qu�
ha vingut i el preu per Km. Tamb� volem emmagatzemar en una col�lecci� els tipus de vitamines
que cont�. Aquesta col�lecci� emmagatzemar� un m�xim de 10 valors.*/

/*EXERCICIS*/
/*1. Defineix els dos tipus de dades: t_nutrient, t_logistica i t_vitamines. Posteriorment defineix la
taula producte per emmagatzemar la informaci� necess�ria.*/
DROP TYPE T_nutrient FORCE;
CREATE OR REPLACE TYPE T_nutrient AS OBJECT(
    calories INT,
    hidrats INT,
    greixos INT
);
drop type T_logistica force;
CREATE OR REPLACE TYPE T_logistica AS OBJECT(
    ciutat VARCHAR2(20),
    transport VARCHAR2(20),
    preuKM NUMBER(4,2)
);

CREATE OR REPLACE TYPE T_vitamines IS VARRAY(10) OF VARCHAR2(2);

DROP TABLE Producte2;
CREATE TABLE Producte2(
    codi CHAR(8) PRIMARY KEY,
    nom VARCHAR2(20) NOT NULL,
    preu NUMBER(10,2) NOT NULL,
    nutrients T_nutrient,
    logistica T_logistica ,
    Vvitamines T_vitamines
);



/*2. Inserim els seg�ents productes: Pera, amb codi PROD0001, a un preu de 1.89, i que t� 100
calories, 20 hidrats i 20 greixos que v� de Murcia, en Cami�, el preuKm es 0.15 i t� com a
vitamines la A i C. El producte Pastanaga, amb codi PROD0002, a un preu de 0.89, i que t� 10
calories, 0 hidrats i 10 greixos, que ve de Zaragoza en cami�, preuKm es 0.21 i com a vitamines
t�: E, C i B. Finalment el producte Mandarina amb codi PROD0003, a un preu de 2.04, amb
120 calories, 20 hidrats i 30 greixos que ve de Roma en Vaixell, preuKm es 0.11 i com a
vitamines t� la A, B1, B2 i la C.*/

INSERT INTO Producte VALUES ('PROD0001','Pera',1.89, T_nutrient(100,20,20),
                                T_logistica('Murcia','Cami�', 0.15),
                                T_vitamines('A','C'));

INSERT INTO Producte VALUES ('PROD0002','Pastanaga',0.89, T_nutrient(10,0,10),
                                T_logistica('Zaragoza','Cami�', 0.21),
                                T_vitamines('E','C','B'));
                                
INSERT INTO Producte VALUES ('PROD0003','Mandarina',2.04, T_nutrient(120,20,30),
                                T_logistica('Roma','Vaixell', 0.11),
                                T_vitamines('A','B1','B2','C'));
                                
SELECT * FROM Producte;

/*3. Cerca el codi, nom i els nutrients (per separats) dels tots els aliments que t� m�s de 15 de greixos y 10 d�hidrats.*/

SELECT codi, nom, P.nutrients.calories, P.nutrients.greixos, P.nutrients.hidrats FROM Producte P WHERE P.nutrients.greixos >15 AND P.nutrients.hidrats >10;

/*4. Mostra el codi i el nom dels productes que costen m�s d�1 euro o b� les seves calories s�n m�s de 90.*/

SELECT codi, nom FROM Producte P WHERE preu > 1 OR P.nutrients.calories >90;

/*5. Cal afegir al tipus t_nutrient, l�atribut Proteines.*/

ALTER TYPE T_nutrient ADD ATTRIBUTE proteines INT CASCADE;

/*6. Incrementa en un 10% tots els nutrients dels aliments que tenen 10 calories*/

UPDATE Producte P SET P.nutrients.calories=P.nutrients.calories+(P.nutrients.calories*0.1), 
    P.nutrients.hidrats=P.nutrients.hidrats+(P.nutrients.hidrats*0.1), 
    P.nutrients.greixos=P.nutrients.greixos+(P.nutrients.greixos*0.1) 
WHERE P. nutrients.calories >10;


/*7. Elimina els productes que tenen hidrats i els greixos superior o igual a 20.*/

DELETE FROM Producte P WHERE P.nutrients.hidrats >=20 AND P.nutrients.greixos >=20;

/*8. Fer un procediment que donat un nom de producte, mostri per pantalla els nutrients que t�.*/

EXECUTE nutrientsProducte('Pera');
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE nutrientsProducte(v_nom Producte2.nom%TYPE) IS
    v_nutrients T_Nutrient;
BEGIN
    SELECT P.nutrients INTO v_nutrients FROM Producte2 P WHERE nom = v_nom;

    DBMS_OUTPUT.PUT_LINE(v_nom);
    DBMS_OUTPUT.PUT_LINE('Calories: '||v_nutrients.calories);
    DBMS_OUTPUT.PUT_LINE('Hidrats: '||v_nutrients.hidrats);
    DBMS_OUTPUT.PUT_LINE('Greixos: '||v_nutrients.greixos);
END;

/*9. Fer un procediment donada un tipus transport que mostri per ciutat quants productes (SELECT)*/

EXECUTE qttProductesTransportCiutat('Cami�');

 SELECT P.logistica.ciutat, COUNT(nom) FROM Producte2 P WHERE P.logistica.transport = 'Cami�' GROUP BY P.logistica.ciutat;

CREATE OR REPLACE PROCEDURE qttProductesTransportCiutat(v_transport Producte2.logistica.transport%TYPE) IS
BEGIN
    -- Caldria inserir el resultat en un cursor i mostrar-lo.
    SELECT P.logistica.ciutat, COUNT(nom) FROM Producte2 WHERE P.logistica.transport = v_transport GROUP BY P.logistica.ciutat;
END;
