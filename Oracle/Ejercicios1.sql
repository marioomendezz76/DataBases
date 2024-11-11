/*Realitzar els següents exercicis partint de la taula ARTICLE que té els camps:
• Codi
• Nom
• Categoria
• Preu
*/

CREATE TABLE Article(
    codi CHAR(8) PRIMARY KEY,
    nom VARCHAR2(30),
    categoria VARCHAR2(20),
    preu NUMBER(6,2)
);
INSERT INTO Article VALUES ('ART00001','Llom adobat','Carn',3.50);
INSERT INTO Article VALUES ('ART00002','Llet desnatada','Làctic',1.50);
INSERT INTO Article VALUES ('ART00003','Costella de xai','Carn',4.50);
INSERT INTO Article VALUES ('ART00004','Iogurt Maduixa','Làctic',1.25);
INSERT INTO Article VALUES ('ART00005','Pernil Ibèric','Carn',13.50);
INSERT INTO Article VALUES ('ART00006','Pebre negre','Espècies',1.60);
INSERT INTO Article VALUES ('ART00007','Orenga','Espècies',1.05);

/*1. Crea un bloc anònim on es crei un RECORD amb els atributs de codi, nom i preu.
    • Instancia una variable amb aquest tipus record i assigna-li uns valors.
    • Posteriorment mostra els valors per pantalla.
*/
SET SERVEROUTPUT ON;
DECLARE 
    TYPE r_article IS RECORD(
        codi article.codi%TYPE,
        nom article.nom%TYPE,
        preu article.preu%TYPE
    );
    a1 r_article;
BEGIN
    a1.codi:='ART0001';
    a1.nom:='Impressora HP';
    a1.preu:=290;

    DBMS_OUTPUT.PUT_LINE('Codi:' || a1.codi);
    DBMS_OUTPUT.PUT_LINE('Nom :' || a1.nom);
    DBMS_OUTPUT.PUT_LINE('Preu:' || a1.preu);
END;

/* 2. Crear una col·lecció que permeti emmagatzemar la informació de fins a 10 valors numèrics.
    • Cal instanciar aquest VARRAY amb els valors 15, 40 i 30.
    • Posteriorment, cal afegir amb un FOR 5 valors més que seran el resultat de la
    següent sèrie: 5, 10, 15, 20, 25.
    És a dir, el VARRAY tindrà: 15,40,30,5,10,15,20,25.
    • Cal calcular la mitja dels números que hi ha en el VARRAY i mostrar-lo per
    pantalla. */

DECLARE
    TYPE T_nums IS VARRAY(10) OF INT;
    vNums T_nums;
    mitja FLOAT:=0;
BEGIN

    vNums:=T_nums(15,40,30);
    
    FOR i in 1..5 LOOP
        vNums.extend(1);    
        vNums(vnums.count):=i*5;
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('El valors de VARRAY són:');
    FOR i in 1..vNums.count LOOP
        mitja:=mitja+vNums(i);
        DBMS_OUTPUT.PUT_LINE(vNums(i));
    END LOOP;
    mitja:=mitja/vNums.count;
    DBMS_OUTPUT.PUT_LINE('La mitja és: ' || mitja);
END;

/* 3. Cal crear una col·lecció que permeti emmagatzemar les dades del mateix tipus creat en l’exercici 1 de forma il·limitada.
    • Cal omplir aquesta col·lecció amb 3 dades de forma completa aleatòriament i
    mostrar-les per pantalla.
    • Un cop realitzat, caldrà afegir en la NESTED TABLE les dades de l’article més barat.
    • Cal mostrar de nou la informació de la taula.
    • Elimina els dos últims elements i torna a mostrar la informació tot mostrant al
    final quants elements hi ha a la col·lecció. */

DECLARE
   TYPE T_Article IS TABLE OF Article%ROWTYPE; 
   vArticle T_Article;

BEGIN
    vArticle:=T_Article();
    vArticle.extend(1);
    vArticle(1).codi:='PROD0001';
    vArticle(1).nom:='Iogurt';
    vArticle(1).categoria:='Làctic';
    vArticle(1).preu:=2.50;
    
     FOR i IN 1..vArticle.count() LOOP
        DBMS_OUTPUT.PUT_LINE('Codi: ' || vArticle(i).codi);
        DBMS_OUTPUT.PUT_LINE('Nom: ' || vArticle(i).nom);
        DBMS_OUTPUT.PUT_LINE('Preu: ' || vArticle(i).preu);
    END LOOP;
    
    vArticle.extend(1);
    
    SELECT * INTO vArticle(vArticle.count()) FROM Article WHERE preu = (SELECT MIN(preu) FROM Article);
    
    FOR i IN 1..vArticle.count() LOOP
        DBMS_OUTPUT.PUT_LINE('Codi: ' || vArticle(i).codi);
        DBMS_OUTPUT.PUT_LINE('Nom: ' || vArticle(i).nom);
        DBMS_OUTPUT.PUT_LINE('Preu: ' || vArticle(i).preu);
    END LOOP;
    
    vArticle.delete(vArticle.count());
    vArticle.delete(vArticle.count());
    
     FOR i IN 1..vArticle.count() LOOP
        DBMS_OUTPUT.PUT_LINE('Codi: ' || vArticle(i).codi);
        DBMS_OUTPUT.PUT_LINE('Nom: ' || vArticle(i).nom);
        DBMS_OUTPUT.PUT_LINE('Preu: ' || vArticle(i).preu);
    END LOOP;

END;


/*4. Crear una col·lecció que pugui contenir la següent informació:
    Pera Poma Meló Plàtan
    4.50 3.45 5.65 2.35
Mostra per pantalla la informació.
Afegeix les següents dades:
    Síndria Préssec
    6.50 3.99
Mostra per pantalla la informació.*/

DECLARE
    TYPE T_Fruita IS TABLE OF NUMBER(4,2) INDEX BY VARCHAR2(20);
    vFruita T_Fruita;
    indexT VARCHAR2(20);

BEGIN
    vFruita('Pera'):=4.5;
    vFruita('Poma'):=3.45;
    vFruita('Meló'):=5.65;
    vFruita('Plàtan'):=2.35;
        
    indexT:=vFruita.first;
    
    WHILE indexT IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(indexT || ':' || vFruita(indexT));
        indexT:=vFruita.next(indexT);
    END LOOP;
    
    vFruita('Síndria'):=6.50;
    vFruita('Prèssec'):=3.99;
    
    indexT:= vFruita.first;
    DBMS_OUTPUT.PUT_LINE('CONTINGUT FINAL: ');
    WHILE (indexT is not null)
     LOOP
         DBMS_OUTPUT.PUT_LINE(indexT || ': ' || vFruita(indexT));
         indexT := vFruita.next(indexT);
      END LOOP;

END;


/* 5. Crear un procediment emmagatzemant que donat el codi d’un producte, mostri per
pantalla la informació d’aquest. En cas que no existeixi, cal utilitzar l’excepció
corresponent. */

CREATE OR REPLACE PROCEDURE infoPRoducte(v_codi article.codi%TYPE) IS
    vfilaArticle article%ROWTYPE;
BEGIN

    SELECT * INTO vfilaArticle FROM Article WHERE codi = v_codi;
    DBMS_OUTPUT.PUT_LINE('Codi: ' || vfilaArticle.codi);
    DBMS_OUTPUT.PUT_LINE('Nom: ' || vfilaArticle.nom);
    DBMS_OUTPUT.PUT_LINE('Categoria: ' || vfilaArticle.categoria);
    DBMS_OUTPUT.PUT_LINE('Preu: ' || vfilaArticle.preu);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No existeix cap article amb el codi: '|| v_codi);
END;

SELECT * FROM Article;
EXECUTE infoProducte('ART00011');

/*6. Crear una funció que retorni el preu mig de tots els productes donada una categoria.*/

CREATE OR REPLACE FUNCTION calculPreuMig(v_Cat article.categoria%TYPE) 
    RETURN NUMBER IS
    mitja NUMBER;
BEGIN
    SELECT AVG(preu) INTO mitja FROM Article WHERE categoria = v_cat;
    RETURN mitja;
END;

DECLARE 
    mitja NUMBER(4,2);
BEGIN
    mitja:=calculPreuMig('Carn');
    DBMS_OUTPUT.PUT_LINE(mitja);

END;