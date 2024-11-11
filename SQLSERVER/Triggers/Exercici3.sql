create database m2uf3CursorsExercici3

use m2uf3CursorsExercici3
go


-- Crea les taules necessaries per fer l'exercici

create or alter procedure crearTaulaProductes as
begin

	if OBJECT_ID('Categoria') is null
		create table  categoria(
			codi char(6) PRIMARY KEY,
			nom varchar(20))
	else print 'Taula categoria ja existeix'

	if OBJECT_ID('Producte') is null
		create table producte(
		codi char(8) primary key,
		nom varchar(20),
		preu MONEY,
		estoc INT,	
		estocMinim INT,	
		estocRecomenat INT,
		categoriaCodi char(6),
		constraint fk_producte_categoria foreign key (categoriaCodi) references Categoria(codi)
			
			
	)
	else print 'Taula producte ja existeix'
end
go

insert into categoria values ('CAT001','Cosmetica'),('CAT002','Alimentacio'),('CAT003','Oficina');
insert into producte values ('PROD0001','Colonia XL',29.50,5,3,10,'CAT001');
insert into producte values ('PROD0002','Desodorant',4.65,8,5,10,'CAT001');
insert into producte values ('PROD0003','Olives',2.50,15,5,20,'CAT002');
insert into producte values ('PROD0004','Patates',1.95,5,3,20,'CAT002');
insert into producte values ('PROD0005','Escopinyes',4.95,6,2,10,'CAT002');
insert into producte values ('PROD0006','Estissores',2.50,10,5,20,'CAT003');
insert into producte values ('PROD0007','Grapadora',4.65,6,4,15,'CAT003');
insert into producte values ('PROD0007','Papelera',9.95,3,15,30,'CAT003');
go


exec crearTaulaProductes
	



-- EXERCICI 1:
-- Fer un procediment per a llistar amb un cursor, cadascun dels productes per
-- categoria. Cal mostrar, codi - nom - preu � estoc

EXEC llistarProductesPerCategoria;
go

CREATE OR ALTER PROCEDURE llistarProductesPerCategoria 
	WITH RECOMPILE AS
BEGIN

	DECLARE cProducte CURSOR LOCAL FOR SELECT codi, nom, preu, estoc, categoriaCodi FROM Producte
			ORDER BY categoriaCodi
	DECLARE @codi CHAR(8)
	DECLARE @nom VARCHAR(20), @categoriaCodi  CHAR(6), @categoriaCodiAnt CHAR(6)=''
	DECLARE @preu MONEY
	DECLARE @estoc INT, @cont INT = 1

	OPEN cProducte

	FETCH NEXT FROM cProducte INTO @codi, @nom, @preu, @estoc, @categoriaCodi

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF(@categoriaCodi != @categoriaCodiAnt) 
		BEGIN
			 PRINT '--------------------------------------------------------------';
			EXEC pintaCapcalera @categoriaCodi
		END
		PRINT ' PROD' + CAST(@cont AS VARCHAR(10)) + ': ' + @Codi + SPACE(1) + '|' + SPACE(1) + @nom + SPACE(19 - LEN(@nom)) + '|' + SPACE(1) + CONVERT(VARCHAR, @preu) + SPACE(14 - LEN(CONVERT(VARCHAR, @preu))) + '|' + SPACE(1) + CONVERT(VARCHAR, @estoc);		
		SET @categoriaCodiAnt = @categoriaCodi
		SET @cont +=1;
		FETCH NEXT FROM cProducte INTO @codi, @nom, @preu, @estoc, @categoriaCodi
	END
	CLOSE cProducte
	DEALLOCATE cProducte


END
GO

CREATE OR ALTER PROCEDURE pintaCapcalera(@categoriaCodi CHAR(6)) AS
BEGIN
    DECLARE @nomCat VARCHAR(20) = (SELECT nom from Categoria WHERE codi = @categoriaCodi)

          PRINT '**************************************************************';
        PRINT '                    CATEGORIA: ' + @nomCat;
        PRINT '**************************************************************';
        PRINT '--------------------------------------------------------------';
        PRINT '|        CODI    |  NOM               |     PREU      | ESTOC |';
        PRINT '---------------------------------------------------------------';
END
GO

-- 2. Fer un procediment donada un nom d�una categoria, retorni la quantitat de
-- productes, l�estoc total, la mitja del preu i el % d�estoc que hi ha respecte el
-- recomanat. Entenem que les categories s�n UNIQUE


CREATE OR ALTER FUNCTION existeixCategoriaNom(@categoriaNom VARCHAR(20))
    RETURNS INT AS 
BEGIN
    RETURN (SELECT COUNT(*) FROM categoria  WHERE nom = @categoriaNom)
    
END
GO

CREATE OR ALTER PROCEDURE infoCategoria (@categoriaNom VARCHAR(20), @qttProductes INT OUT, @estoc INT  OUT, @preuMitja FLOAT  OUT, @percentatge FLOAT OUT)
     WITH RECOMPILE AS
BEGIN
    SET NOCOUNT ON
    IF(LEN(@categoriaNom) = 0 OR LEN(@categoriaNom)>20) PRINT 'No s''ha inserit cap nom de categoria valid (0/20).'
    ELSE IF(dbo.existeixCategoriaNom(@categoriaNom)=0) PRINT 'La categoria (' + @categoriaNom + ') no existeix.'
    ELSE
    BEGIN
		-- Anem a buscar el codi de la categoria
        DECLARE @categoriacodi CHAR(6) = ( SELECT codi FROM Categoria WHERE nom = @categoriaNom)


        DECLARE @estocRec INT = (SELECT SUM(estocRecomenat) FROM Producte WHERE categoriaCodi=@categoriacodi)
        
        SET @qttProductes = (SELECT COUNT(*) FROM Producte WHERE categoriaCodi=@categoriacodi)
        SET @estoc = (SELECT SUM(estoc) FROM Producte WHERE categoriaCodi=@categoriacodi)
        SET @preuMitja = (SELECT AVG(CAST(preu AS MONEY)) FROM Producte WHERE categoriaCodi=@categoriacodi)
        SET @percentatge = @estoc/CAST(@estocRec AS FLOAT)*100

		-- NOTA: Els SETS anteriors, es podrien fer amb un UNIC SELECT
		
    END
END
GO

BEGIN
    DECLARE @qttProductes INT, @estoc INT
    DECLARE @preuMitja FLOAT, @percentatge FLOAT
    DECLARE @nomCat VARCHAR(20)='Cosmetica'

    EXEC infoCategoria @nomCat, @qttProductes OUT, @estoc OUT, @preuMitja OUT, @percentatge OUT

    PRINT '***************************************'
    PRINT 'Categoria: ' + @nomCat
    PRINT '***************************************'
    PRINT 'Quantitat de productes: ' + CAST(@qttProductes AS CHAR(10))
    PRINT 'Estoc disponible: ' + CAST(@estoc AS CHAR(10))
    PRINT 'Mitja de preus: ' + CAST(ROUND(@preuMitja,2) AS VARCHAR(10)) + ' �'
    PRINT 'Hi ha ' + CAST(@percentatge AS CHAR(2))+'% respecte al estoc recomenat'
END
GO

/* 3.
Fer un procediment utilitzant un cursor, que actualitzi el preu i estoc dels
productes d�acord a les seg�ents condicions:
a. Augmentar el preu un 15%, si el total de productes diferents d�aquella
categoria es inferior a 50 i el preu del producte �s superior a la mitja de la
seva categoria.
b. Augmentar un 10% l�estoc recomanat d�aquell producte si la suma de l�estoc
recomanat dels productes de la seva categoria �s inferior a 100.
c. Deixar l�estoc m�nim en 5 unitats a tots els productes que tinguin la mateixa
categoria igual a l�anterior producte del cursor.
d. Eliminar el producte si l�estoc m�nim es superior al recomanat.
Cal posar en una taula anomenada �prodsModificatsLog� on es posin de cada
producte actualitzat o modificat, els codis, noms, preu anterior i posterior al
canvi, estoc m�nim modificat, estoc recomanat anterior i posterior al canvi, la
data/hora del nou registre i el tipus de modificaci� (�ACTUALITZAT�,
�ELIMINAT�). En cas que el tipus sigui ELIMINAT, nom�s caldr� emplenar el
codi, nom, data i hora del registre eliminat.
Haur� de mostrar per pantalla, quants canvis de preu, estocs recomanats,
estocs m�nims i productes eliminats s�han produ�t.*/

EXEC actualitzarProductes;

select * from taulaProductesMod;


CREATE OR ALTER PROCEDURE actualitzarProductes
	WITH RECOMPILE AS
BEGIN

	SET NOCOUNT ON
	DECLARE @codi CHAR(8), @categoriaCodi CHAR(6), @categoriaCodiAnt CHAR(6)='',@nom VARCHAR(20)
	DECLARE @preu MONEY
	DECLARE @estoc INT,@estocMinim INT,@estocRecomenat INT
	DECLARE @qttPreu INT =0, @qttEstocRecomenat INT = 0, @qttEstocMinim INT =0, @qttEliminats INT = 0;
      
    DECLARE cMegaActualitzacio CURSOR FOR SELECT codi, nom, preu, estoc,estocMinim,estocRecomenat,categoriaCodi FROM producte 

	EXEC crearTaulaLog

	OPEN cMegaActualitzacio 

	FETCH NEXT FROM cMegaActualitzacio INTO @codi, @nom, @preu, @estoc,@estocMinim,@estocRecomenat,@categoriaCodi

	WHILE(@@FETCH_STATUS=0)
	BEGIN

		-- CAS A:
		IF((dbo.qttProdsCategoria(@categoriaCodi) < 50) AND (@preu > dbo.mitjaProdsCategoria(@categoriaCodi)))
		BEGIN
			INSERT INTO taulaProductesMod VALUES (@codi,@nom,@preu,@preu*1.15,@estocMinim,@estocMinim,@estocRecomenat,@estocRecomenat,GETDATE(),'ACTUALITZAT');
			UPDATE Producte SET preu = preu*1.15 WHERE codi = @codi;
			SET @qttPreu +=1;
			
		END
		-- CAS B:
		IF(dbo.totalEstocRecomanat(@categoriaCodi) <100)
		BEGIN
			INSERT INTO taulaProductesMod VALUES (@codi,@nom,@preu,@preu,@estocMinim,@estocMinim,@estocRecomenat,@estocRecomenat*1.1,GETDATE(),'ACTUALITZAT');
			UPDATE Producte SET @estocRecomenat = @estocRecomenat *1.1 WHERE codi = @codi
			SET @qttEstocRecomenat+=1;
		END

		-- CAS C:
		IF(@categoriaCodi=@categoriaCodiAnt)
		BEGIN
			INSERT INTO taulaProductesMod VALUES (@codi,@nom,@preu,@preu,@estocMinim,5,@estocRecomenat,@estocRecomenat,GETDATE(),'ACTUALITZAT');
			UPDATE Producte SET @estocMinim = 5 WHERE codi = @codi
			SET @qttEstocMinim+=1;
		END
		-- CAS D:
		IF(@estocMinim>@estocRecomenat)
		BEGIN
			INSERT INTO taulaProductesMod VALUES (@codi,@nom,NULL,NULL,NULL,NULL,NULL,NULL,GETDATE(),'ELIMINAT');
			DELETE FROM Producte WHERE codi = @codi
			SET @qttEliminats +=1;
		END

		SET @categoriaCodiAnt  = @categoriaCodi
		FETCH NEXT FROM cMegaActualitzacio INTO @codi, @nom, @preu, @estoc,@estocMinim,@estocRecomenat,@categoriaCodi
	END

	CLOSE cMegaActualitzacio 
	DEALLOCATE cMegaActualitzacio 
	EXEC pintaResum @qttPreu , @qttEstocRecomenat, @qttEstocMinim, @qttEliminats;

END
GO

CREATE OR ALTER PROCEDURE crearTaulaLog
    WITH RECOMPILE AS
BEGIN
    IF (OBJECT_ID('taulaProductesMod') IS NOT NULL) DROP TABLE taulaProductesMod
    CREATE TABLE taulaProductesMod (
        codi CHAR(8),
        nom VARCHAR(20),
        preuAnterior MONEY,
        preuNou MONEY,
        estocMinimAnterior INT,
        estocMinimNou INT,
        estocRecomenatAnterior INT,
        estocRecomenatNou INT,
        dataHora DATETIME,
        tipusModificacio VARCHAR(20)
    )
END
GO

CREATE OR ALTER PROCEDURE pintaResum (@qttPreu INT, @qttEstocRecomenat INT, @qttEstocMinim INT, @qttEliminats INT)
AS
BEGIN
 
    PRINT '***************************************'
    PRINT 'MODIFICACIONS REALITZADES'
    PRINT '***************************************'
    PRINT 'Modificacions de preu:' + CAST(@qttPreu AS VARCHAR(6))
    PRINT 'Modificacions d''estoc Recomenat: ' + CAST(@qttEstocRecomenat AS VARCHAR(6))
    PRINT 'Modificacions d''estoc Minim: ' + CAST(@qttEstocMinim AS VARCHAR(6))
    PRINT 'Productes eliminats: ' + CAST(@qttEliminats AS VARCHAR(6))
END
GO

CREATE OR ALTER FUNCTION qttProdsCategoria(@categoriaCodi CHAR(6)) 
    RETURNS INT AS
BEGIN
    RETURN (SELECT COUNT(*) FROM producte WHERE categoriaCodi = @categoriaCodi)
END
GO
CREATE OR ALTER FUNCTION mitjaProdsCategoria(@categoriaCodi CHAR(6)) 
    RETURNS INT AS
BEGIN
    RETURN (SELECT AVG(preu) FROM producte WHERE categoriaCodi = @categoriaCodi)
END
GO
CREATE OR ALTER FUNCTION totalEstocRecomanat(@categoriaCodi CHAR(6)) 
    RETURNS INT AS
BEGIN
    RETURN (SELECT SUM(estocRecomenat) FROM producte WHERE categoriaCodi = @categoriaCodi)
END
GO

/* 4.
Fer un procediment cre� una taula amb els productes que estan per sota de
l�estoc m�nim i faci la comanda autom�ticament respectacant l�estoc recomanat
d�aquell producte. La taula ha de tenir els camps: CodiProd, NomProd i Estoc a
demanar. Cal tenir en compte l�estoc actual que hi ha.
Per exemple:
Si el prod ABC10 t� un estoc m�nim de 5, amb un estoc recomanat de 15, i
actualment hi ha un estoc de 3. Caldr� demanar 12 unitats d�aquest.�
*/

SELECT * FROM Producte;
UPDATE Producte SET estoc = 2 WHERE categoriaCodi ='CAT002';
GO
SELECT * FROM Comanda_Demanada;

EXEC ferComanda;
GO

CREATE OR ALTER PROCEDURE ferComanda 
	WITH RECOMPILE AS
BEGIN
	SET NOCOUNT ON
	DECLARE cProducte CURSOR LOCAL FOR SELECT codi, nom, estoc, estocMinim, estocRecomenat FROM Producte;
	DECLARE @codi CHAR(8)
	DECLARE @nom VARCHAR(20)
    DECLARE @estoc INT, @qttProdsADemanar INT = 0
    DECLARE @estocMin INT
    DECLARE @estocRecomenat INT

	OPEN cProducte;

	
	FETCH NEXT FROM cProducte INTO @codi, @nom, @estoc, @estocMin, @estocRecomenat
	
	IF(@@FETCH_STATUS=0) EXEC crearTaulaComanda

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		
		IF(@estoc < @estocMin) 
		BEGIN
			INSERT INTO Comanda_Demanada VALUES (getdate(),  @codi, @nom, @estocRecomenat-@estoc)
			SET @qttProdsADemanar+=1
		END
		FETCH NEXT FROM cProducte INTO @codi, @nom, @estoc, @estocMin, @estocRecomenat
	END
	CLOSE cProducte;
	DEALLOCATE cProducte;
	PRINT 'Total de productes a demanar:' + CAST(@qttProdsADemanar AS CHAR(3))
END
go

CREATE OR ALTER PROCEDURE crearTaulaComanda AS
BEGIN
    IF (OBJECT_ID('Comanda_Demanada') IS NOT NULL) DROP TABLE Comanda_Demanada
    CREATE TABLE Comanda_Demanada (
        dataC DATETIME,
		codi CHAR(8),
        nom VARCHAR(20),
        unitats INT, --LO QUE HAY QUE COMPRAR
    )
END
GO