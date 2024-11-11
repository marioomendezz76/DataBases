CREATE database DAM_CursorsExercici1;
use DAM_CursorsExercici1;
go

CREATE or ALTER procedure crearTaules as
BEGIN
	
	IF OBJECT_ID('ExtresLloguer') IS NOT NULL
		drop table ExtresLloguer
	IF OBJECT_ID('Extra') IS NOT NULL
		drop table Extra
	IF OBJECT_ID('Lloguer') IS NOT NULL
		drop table Lloguer
	IF OBJECT_ID('client') IS NOT NULL
		drop table client
	IF OBJECT_ID('cotxe') IS NOT NULL
		drop table cotxe
	IF OBJECT_ID('Client') IS NOT NULL
		drop table Client
	
	CREATE TABLE client(
		DNI char(9) primary key,
		nomComplet varchar(20),
		telefon varchar(9) unique
	);
	
	CREATE TABLE cotxe(
		matricula char(8) primary key,
		marca VARCHAR(20),
		model VARCHAR(20),
		preuDia money,
		categoria varchar(5), -- Alta,  Baixa
		estat int default 0, -- 0:Lliure, 1:Lloguer, 2: Revisió, 3: Baixa
		kmActuals int,
		qttLlogat INT DEFAULT 0
	);


	CREATE TABLE extra(
		nom varchar(20) primary key,
		preuDiari money,
		unitatsDisponibles tinyint,
		categoriaCotxe varchar(20) -- Alta, Baixa
		
	);

	
	CREATE TABLE lloguer(
		referencia CHAR(5) PRIMARY KEY,
		clientDNI char(9),
		cotxeMatricula char(8),
		dataInici date,
		dataFinal date,
		kmRealitzats int,
		constraint fk_lloguer_client foreign key (clientDNI) references client(DNI)
			ON UPDATE CASCADE ON DELETE NO ACTION,
		constraint fk_lloguer_cotxe foreign key (cotxeMatricula) references cotxe(matricula)
			ON UPDATE CASCADE ON DELETE NO ACTION
		);
	CREATE TABLE ExtresLloguer(
		lloguerReferencia CHAR(5),
		extraNom VARCHAR(20),
		PRIMARY KEY(lloguerReferencia,extraNom),
		CONSTRAINT fk_extresLloguer_lloguer foreign key(lloguerReferencia) references Lloguer(referencia)
			ON UPDATE CASCADE ON DELETE NO ACTION,
		CONSTRAINT fk_extresLloguer_extra foreign key(extraNom) references Extra(nom)
			ON UPDATE CASCADE ON DELETE NO ACTION,
	);
	
	PRINT 'Taules inserides correctament'

end
go

CREATE or ALTER procedure inserirInformacio 
	WITH RECOMPILE AS
BEGIN

	SET NOCOUNT ON

	INSERT INTO client VALUES ('11233444A','Marc Prats','666114477'), ('11233444B','Anna Martínez','666223344'),
		('11233444C','Pol Hernández','666112200'),('11233444D','Susana Andrés','655778899');
		
	INSERT INTO cotxe VALUES ('1111-AAA','Opel','Astra',45,'Alta',0,13200,1);
	INSERT INTO cotxe VALUES ('2222-BBB','Toyota','Yaris',70,'Baixa',0,26000,3);
	INSERT INTO cotxe VALUES ('3333-CCC','Renault','Megane',125,'Alta',0,1100,0);
	INSERT INTO cotxe VALUES ('4444-DDD','Toyota','CHR',45,'Alta',3,13200,1);
	INSERT INTO cotxe VALUES ('5555-EEE','Mercedes','Clase A',80,'Alta',1,4500,1);
	
	INSERT INTO extra VALUES ('GPS',30,5,'Alta'),('AACC',20,10,'Baixa'),('ParkTrònic',40,10,'Alta'),
			('Cadireta Baby',50,5,'Baixa'),('Porta Bicicletes',15,10,'Baixa'),('Spotify',20,100,'Alta');
	
	INSERT INTO Lloguer VALUES ('REF01','11233444A','1111-AAA','2022-01-02','2022-01-15',300);
	INSERT INTO Lloguer VALUES ('REF02','11233444B','2222-BBB','2022-02-16','2022-03-01',200);
	INSERT INTO Lloguer VALUES ('REF03','11233444A','4444-DDD','2022-03-25','2022-04-15',450);
	INSERT INTO Lloguer VALUES ('REF04','11233444D','2222-BBB','2022-01-15','2022-01-24',150);
	INSERT INTO Lloguer VALUES ('REF05','11233444D','2222-BBB','2022-02-25','2022-03-05',850);
	INSERT INTO Lloguer VALUES ('REF06','11233444A','5555-EEE','2022-05-01','2022-05-02',200);
	INSERT INTO Lloguer VALUES ('REF07','11233444A','5555-EEE','2022-05-01',NULL,NULL);	

	INSERT INTO ExtresLloguer VALUES ('REF01','GPS'),('REF01','ParkTrònic'),('REF01','AACC'),('REF01','Porta Bicicletes'),('REF01','Spotify');
	INSERT INTO ExtresLloguer VALUES ('REF02','AACC'), ('REF02','Cadireta Baby');
	INSERT INTO ExtresLloguer VALUES ('REF03','GPS'),('REF03','Spotify');
	INSERT INTO ExtresLloguer VALUES ('REF04','GPS'),('REF04','ParkTrònic'),('REF04','AACC');
	INSERT INTO ExtresLloguer VALUES ('REF06','AACC'),('REF06','Spotify');

	PRINT 'Dades inserides correctament'
end
go


EXEC CrearTaules;
EXEC InserirInformacio;

-- *****************  EXERCICI 1 ********************
/*1.	Fer un procediment que donat una marca d’un cotxe escollida per un usuari, mostri un llistat amb la matrícula, model, kmActuals, preuDia i preu amb IVA (21%).
Cal verificar que:
•	S’hagi introduït una marca en la crida
•	Hi hagi algun cotxe d’aquella marca, en cas contrari ha d’indicar que no hi ha cotxes d’aquella marca.

Cal mostrar un encapçalament amb el nom de la marca i al final un total de cotxes del llistat.
Exemple: EXEC llistarCotxesSegonsMarca 'Toyota'
*/
EXEC llistarCotxesSegonsMarca 'Toyota'
GO

CREATE OR ALTER FUNCTION qttCotxesSegonsMarca(@marca VARCHAR(20))
    RETURNS INT AS
BEGIN
    RETURN (SELECT COUNT(marca) FROM cotxe WHERE marca=@marca)
END
GO

CREATE OR ALTER PROCEDURE pintaCapcalera AS
BEGIN
	PRINT 'MATRICULA' + REPLICATE(' ', 5) + 'MODEL' + REPLICATE(' ', 5) + 'KM ACTUALS' + REPLICATE(' ', 5) + 'PREU/DIA' + REPLICATE(' ', 5) + 'PREU/IVA'
END
GO

CREATE OR ALTER PROCEDURE llistarCotxesSegonsMarca(@marca VARCHAR(20))
	WITH RECOMPILE AS
BEGIN
	IF(LEN(@marca) =0 OR @marca IS NULL) PRINT 'Cal que indiquis la marca per llistar'
	ELSE IF(dbo.qttCotxesSegonsMarca(@marca)=0) PRINT 'No hi ha cotxes d''aquesta marca'
	ELSE
	BEGIN
		EXEC pintaCapcalera

		DECLARE @matricula CHAR(15)
		DECLARE @model VARCHAR(10)
		DECLARE @kmActuals INT
		DECLARE @preuDia MONEY
		DECLARE @preuIva MONEY
		DECLARE cCotxe CURSOR FOR SELECT matricula, model, kmActuals, preuDia FROM cotxe
					WHERE marca = @marca
		
		OPEN cCotxe

		FETCH NEXT FROM cCotxe INTO @matricula, @model, @kmActuals, @preuDia
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			SET @preuIva = @preuDia*1.21
			PRINT @matricula + @model + CAST(@kmActuals AS CHAR(10)) + CAST(@preuDia AS CHAR(6)) + CAST(@preuDia AS VARCHAR(6))
			FETCH NEXT FROM cCotxe INTO @matricula, @model, @kmActuals, @preuDia
		END
		CLOSE cCotxe
		DEALLOCATE cCotxe
	END
END
GO


-- *****************  EXERCICI 2 ********************
/*2.	Donada una referencia de lloguer, mostrar un llistat amb tots els extres d’aquests, juntament amb el preu que ha suposat en el lloguer cadascun.
Cal verificar que:
•	La referencia del lloguer existeixi.
•	Que el lloguer hagi tingut algun extra, en cas contrari ha d’indicar que no hi ha cap extra afegit.
Cal mostrar un encapçalament del lloguer on es vegi la referencia, matricula, data inici i dataFi.
Al final també cal mostrar el preu final del lloguer: Preu cotxe + preu Extres.
	El procediment s’ha d’anomenar: mostrarExtresLloguer.

*/
CREATE OR ALTER FUNCTION existeixLloguer(@referencia CHAR(5))
	RETURNS INT AS
BEGIN
	RETURN (SELECT COUNT(referencia) FROM LLOGUER WHERE referencia=@referencia)
END
GO
CREATE OR ALTER FUNCTION qttDiesLloguer(@referencia CHAR(5))
	RETURNS INT AS
BEGIN
	RETURN (SELECT DATEDIFF(DAY,dataInici,dataFinal) FROM Lloguer WHERE referencia=@referencia)
END
GO

CREATE OR ALTER PROCEDURE mostrarDadesLloguer(@referencia CHAR(5),@diesLloguer INT)
	WITH RECOMPILE AS
BEGIN
	DECLARE @matricula CHAR(8)
	DECLARE @dataI DATE, @dataF DATE
	
	SELECT @matricula = cotxeMatricula, @dataI = dataInici, @dataF = dataFinal FROM Lloguer
		WHERE referencia = @referencia

	PRINT REPLICATE('*',8) + 'DADES LLOGUER ' + REPLICATE('*',8)
	PRINT 'REFERENCIA: ' + @referencia
	PRINT 'MATRICULA: ' + @matricula
	PRINT 'DATA INICI: ' + CAST(@dataI AS VARCHAR(10))
	PRINT 'DATA FI: ' + CAST(@dataF AS VARCHAR(10))
	PRINT 'TOTAL DIES: ' + CAST(@diesLloguer AS CHAR(3))
END
GO
CREATE OR ALTER FUNCTION qttExtresLloguer(@referencia CHAR(5))
	RETURNS INT AS 
BEGIN
	RETURN (SELECT COUNT(*) FROM ExtresLloguer WHERE lloguerReferencia = @referencia)
END
GO
CREATE OR ALTER PROCEDURE obtenirExtresLloguer(@referencia CHAR(5), @diesLloguer INT)
	WITH RECOMPILE AS
BEGIN
	IF(dbo.qttExtresLloguer(@referencia) = 0) PRINT 'No hi ha extres afegits'
	ELSE
	BEGIN
		PRINT REPLICATE('*',8) + 'LLISTAT DE EXTRES DEL COTXE ' + REPLICATE('*', 8)

		DECLARE @nom CHAR(10)
		DECLARE @preu MONEY
		DECLARE cExtres CURSOR FOR SELECT E.nom, E.preuDiari FROM Extra E
							INNER JOIN ExtresLloguer EL ON E.nom = EL.extraNom
							WHERE EL.lloguerReferencia = @referencia
		OPEN cExtres
		FETCH NEXT FROM cExtres INTO @nom, @preu
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			PRINT @nom + CAST(@preuDiari AS CHAR(10)) + CAST(@preuDiari*@diesLloguer AS VARCHAR(10))
			FETCH NEXT FROM cExtres INTO @nom, @preu
		END
		CLOSE cExtres
		DEALLOCATE cExtres
	END 
END
GO

CREATE OR ALTER PROCEDURE mostrarExtresLloguer(@referencia CHAR(5))
	WITH RECOMPILE AS
BEGIN
	DECLARE @diesLloguer INT
	IF(dbo.existeixLloguer(@referencia) = 0) PRINT 'Aquesta referencia no existeix'
	ELSE
	BEGIN
	SET @diesLloguer = dbo.qttDiesLloguer(@referencia)

	EXEC mostrarDadesLloguer @referencia, @diesLloguer 
	EXEC mostrarExtresLloguer @referencia, @diesLloguer
	EXEC mostrarResumLloguer @referencia, @diesLloguer

	END
END
GO



-- *****************  EXERCICI 3 ********************

/*3.	Fer un procediment que es mostri el total de cotxes que hi ha en els seus diferents estats (0:Lliure, 1:Lloguer, 2: Revisió, 3: Baixa).
*/
CREATE OR ALTER FUNCTION conversorEstat(@estat INT)
	RETURNS CHAR(10) AS
BEGIN
	DECLARE @estatText CHAR(10)

	SELECT @estatText = CASE
			WHEN @estat = 0 THEN 'LLIURE'
			WHEN @estat = 1 THEN 'LLOGUER'
			WHEN @estat = 2 THEN 'REVISIÓ'
			WHEN @estat = 3 THEN 'BAIXA'
	END
END
GO

CREATE OR ALTER PROCEDURE llistatQttCotxesSegonsEstat
	WITH RECOMPILE AS
BEGIN
	DECLARE @estat TINYINT, @qttCotxes INT
	DECLARE @i INT = 0
	WHILE (@i<=3)
	BEGIN
		SET @qttCotxes = (SELECT COUNT(*) FROM cotxe WHERE estat = @i)
		PRINT @dbo.
		SET @i = @i+1
	END

	CLOSE cEstat
	DEALLOCATE cEstat
END
GO
EXEC llistatQttCotxesSegonsEstat
GO
-- *****************  EXERCICI 4 ********************

/*
Fer un procediment que donat un DNI d’un client mostri un llistat de tots els
lloguers (REFs) juntament amb la marca i model que ha tingut.
Cal verificar que el dni del client existeixi.
Al final, cal mostrar el cost total només dels lloguers, no cal tenir en compte els
extres.*/

EXEC mostrarLloguersClient '11233444A'
GO
CREATE OR ALTER FUNCTION existeixClient(@DNI CHAR(9))
    RETURNS BIT AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Client WHERE DNI = @DNI)
END
GO
CREATE OR ALTER FUNCTION existeixMatricula(@matricula CHAR(8))
    RETURNS BIT AS
BEGIN
    RETURN (SELECT COUNT(*) FROM cotxe WHERE @matricula = matricula)
END
GO
CREATE OR ALTER PROCEDURE pintaCapcelera AS
BEGIN
    PRINT 'Referència  |  Marca      |  Model     |  CostLloguer'
    PRINT '-----------------------------------------------------'
END
GO
CREATE OR ALTER PROCEDURE mostrarLloguersClient(@DNI CHAR(9))
	WITH RECOMPILE AS
BEGIN
	--IF(dbo.existeixClient(@DNI) = 0) PRINT 'Aquest client no està a la base de dades'
	--ELSE IF(dbo.qttLloguersClient(@DNI)=0) PRINT 'Aquest client encara no ha realitzat cap lloguer'
	--ELSE
	BEGIN
		DECLARE @ref CHAR(8), @marca CHAR(20), @model CHAR(20), @costLloguer MONEY
		DECLARE @acumLloguer MONEY=0
		DECLARE cLloguer CURSOR FOR SELECT L.referencia, C.marca, C.model, DATEDIFF(DAY, L.dataInici, L.dataFinal)*c.preuDia 
			FROM lloguer L INNER JOIN cotxe C ON C.matricula = L.cotxeMatricula
			WHERE L.clientDNI = @dni
		
		EXEC pintaCapcelera
		OPEN cLloguer

		FETCH NEXT FROM cLloguer INTO @ref, @marca, @model, @costLloguer
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			IF(@costLloguer IS NULL)
			BEGIN
				SET @costLloguer = 0
				PRINT @ref + @marca + @model + 'Lloguer actiu'
			END
			ELSE PRINT @ref + @marca + @model + CAST(@costLloguer AS CHAR(8))
			SET @acumLloguer = @acumLloguer + @costLloguer
			FETCH NEXT FROM cLloguer INTO @ref, @marca, @model, @costLloguer
		END

		CLOSE cLloguer
		DEALLOCATE cLloguer
		PRINT 'COST TOTAL: '+ CAST(@acumLloguer AS VARCHAR(10))

	END
END
GO

-- *****************  EXERCICI 5 ********************
/*5. Donada una matrícula d’un cotxe, mostrar un llistat ordenat per data de més
antic a més recent de:
DATA INICI | REF | DNI | DIES LLOGUER | KM REALITZATS | ACUM KM
Cal verificar que la matricula existeixi.*/
EXEC mostrarLlistatOrdenat '2222-BBB'
GO
CREATE OR ALTER PROCEDURE pintaCapcaleraCotxe AS
BEGIN
    PRINT '** LLISTAT LLOGUER PER MATRICULA **'
    PRINT 'DATA INICI   ' + '|'+ '  REF  ' + '|' + '        DNI  ' + '|' + ' DIES LLOGUER  ' + '|' + ' KM REALITZATS  ' + '|' + '  ACUM KM'
END
GO
CREATE OR ALTER PROCEDURE mostrarLlistatOrdenat(@matricula CHAR(8))
	WITH RECOMPILE AS
BEGIN
	--IF(dbo.existeixCotxe(@matricula)) PRINT 'El cotxe no està a la base de dades.'
	--ELSE IF(dbo.qttCotxesSegonsCotxe(@matricula)=0) PRINT 'el cotxe no té cap lloguer.'
	--ELSE
	BEGIN
		DECLARE @dataInici DATE, @ref CHAR(14), @DNI CHAR(12), @dies INT, @kmRealitzats INT, @acumKm INT=0
		DECLARE cLloguer CURSOR LOCAL FOR SELECT dataInici, referencia, clientDNI,
			 DATEDIFF(DAY, dataInici, dataFinal), kmRealitzats
			 FROM lloguer
			 WHERE cotxeMatricula = @matricula
			 ORDER BY dataInici ASC
		OPEN cLloguer
		EXEC pintaCapcaleraCotxe
		FETCH NEXT FROM cLloguer INTO @dataInici, @ref, @DNI, @dies, @kmRealitzats
		WHILE (@@FETCH_STATUS=0)
		BEGIN
			SET @acumKm=@acumKm+@kmRealitzats
			PRINT CAST(@dataInici AS CHAR(15))  + @ref + @DNI + CAST(@dies AS CHAR(16)) + CAST(@kmRealitzats AS CHAR(18)) + CAST(@acumKm AS VARCHAR )
			FETCH NEXT FROM cLloguer INTO @dataInici, @ref, @DNI, @dies, @kmRealitzats
		END
		CLOSE cLloguer
		DEALLOCATE cLloguer
	END
END
GO
