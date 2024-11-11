CREATE DATABASE m02_uf03_cursors_Exercici2;
USE m02_uf03_cursors_Exercici2;
GO;

/* 1.Fer un procediment per a crear les taules amb els seus camps i les seves
relacions. Cal complir amb les restriccions CHECK de màxim files i columnes.*/

CREATE OR ALTER PROCEDURE crearTaules
    WITH RECOMPILE AS
BEGIN
    if(OBJECT_ID('seient')IS NOT NULL)
    DROP TABLE seient
    
    if(OBJECT_ID('avio')IS NOT NULL)
    DROP TABLE avio

    CREATE TABLE avio(
    codi CHAR(8) primary key,
    nom VARCHAR(25),
    maxFila TINYINT,
    maxCol TINYINT,
    CONSTRAINT maxfila CHECK(maxfila >= 10 AND maxfila <= 30),
    CONSTRAINT maxColumn CHECK(maxCol >= 6 AND maxCol <= 12)
)

CREATE TABLE seient(
    fila TINYINT,
    columna TINYINT,
    finestra BIT,
    tipus CHAR(1),
    ocupat BIT,
    avioCodi CHAR(8)

    PRIMARY KEY(avioCodi,fila,columna),
    constraint fk_avio foreign key(avioCodi) REFERENCES avio(codi)
)

END
GO

EXEC crearTaules
GO



/* EXERCICI 1.
Crea un procediment per a introduir avions.
Cal tenir en compte que l’usuari hagi inserir el codi i el nom. També cal
verificar que l’avió no estigui ja inserit a la taula
Cal controlar que els avions tinguin entre 10 i 30 files.
Cal controlar que els avions tinguin entre 6 i 12 columnes.
→ exec inserirAvio ‘AIR003’, ‘AIRBUSS 747’, 20, 10*/
EXEC inserirAvio 'AIR00003', 'AIRBUSS 747', 20, 8
GO
CREATE OR ALTER FUNCTION filesCorrectes(@maxFila TINYINT)
    RETURNS INT AS
BEGIN
    DECLARE @correcte INT
    IF(@maxFila<10 OR @maxFila>30) SET @correcte = 1
    ELSE SET @correcte = 0
    RETURN @correcte
END
GO
CREATE OR ALTER FUNCTION columnesCorrectes(@maxCol TINYINT)
    RETURNS INT AS
BEGIN
    DECLARE @correcte INT  
    IF(@maxCol<6 OR @maxCol>12) SET @correcte = 1
    ELSE SET @correcte = 0
    RETURN @correcte
END 
GO
CREATE OR ALTER FUNCTION existeixAvio(@codi CHAR(8))
    RETURNS INT AS
BEGIN
    RETURN (SELECT COUNT(*) FROM avio WHERE codi = @codi)
END
GO
CREATE OR ALTER PROCEDURE inserirAvio(@codi CHAR(8), @nom VARCHAR(25), @maxFila TINYINT, @maxCol TINYINT)
    WITH RECOMPILE AS
BEGIN
    IF (@codi IS NULL OR @nom IS NULL) PRINT 'Falten valors'
    ELSE IF(LEN(@codi)!=8) PRINT 'El codi ha de ser de 8 caràcters'
    ELSE IF (dbo.existeixAvio(@codi) = 1) PRINT 'Aquest avió ja existeix'
    ELSE IF(dbo.filesCorrectes(@maxFila)=1 OR dbo.columnesCorrectes(@maxCol)=1) PRINT 'Incorrecte, l''avió ha de tenir entre 10 i 30 files i entre 6 i 12 columnes.'
    ELSE INSERT INTO avio VALUES (@codi, @nom, @maxFila, @maxCol)
END
GO
/* EXERCICI 2.
Fes un procediment per donar d’alta tots els seients d’un avió (qualsevol).
Cada fila i columna comença per 1.
El procediment ha de tenir en compte si és finestra o no.
Cal que l’avió existeixi.
Cal tenir en compte que el procediment ha de crear tants seients com files i
columnes tingui l’avio. Cal tenir present també, que les 4 primeres files de
l’avió sempre seran de “Primera Classe”, o sigui ‘P’; la resta seran de classe
“Turista”: ‘T’ El procediment serà de la següent forma:
exec crearSeients ‘AIR003*/

EXEC crearSeients 'AIR003'
GO
SELECT * FROM avio
GO

CREATE OR ALTER FUNCTION existeixSeient(@codi char(8))
RETURNS INT AS
BEGIN
    RETURN (SELECT COUNT(*) FROM seient where avioCodi=@codi)
END
GO

CREATE OR ALTER PROCEDURE cercaFilaCol (@codi CHAR(8), @maxFila TINYINT OUT, @maxCol TINYINT OUT)
    WITH RECOMPILE AS
BEGIN
    SELECT @maxFila= maxFila, @maxCol=maxCol FROM Avio WHERE codi = @codi
END
GO

CREATE OR ALTER PROCEDURE crearSeients(@codi CHAR(8))
    WITH RECOMPILE AS
BEGIN
    SET NOCOUNT ON
    DECLARE @maxFila TINYINT, @maxCol TINYINT
    DECLARE @fila TINYINT=1, @col TINYINT = 1
    DECLARE @tipus CHAR(1) = 'P'
    DECLARE @finestra BIT

    IF(dbo.existeixAvio(@codi)=0) PRINT 'L''avió no existeix'
    ELSE IF (dbo.existeixSeient(@codi)>0) PRINT 'Seients ja creats'
    ELSE
    BEGIN
        EXEC cercaFilaCol @codi, @maxFila OUT, @maxCol OUT
        WHILE(@fila <=@maxFila)
        BEGIN
            IF(@fila=5) SET @tipus = 'T'
            WHILE(@col<=@maxCol)
            BEGIN
                IF(@col = 1 OR @col = @maxCol) SET @finestra = 1
                ELSE SET @finestra=0
                INSERT INTO Seient VALUES (@fila, @col, @finestra, @tipus, 0, @codi)
                SET @col+=1
            END
            SET @fila+=1
            SET @col+=1
        END
    END
    PRINT 'S''han generat els seients correctament'
END 
GO
/* EXERCICI 3.Fer un procediment anomenat ‘ pintaInformeAvio’ que donat el codi d’un avió,
mostri per pantalla tots els seients que té (fila, col, finestra y tipus).
Cal verificar que l’avió existeixi.
Cal verificar que tingui seients creats.*/
CREATE OR ALTER PROCEDURE pintaCapcaleraAvio(@codi CHAR(8)) AS
BEGIN
    PRINT 'INFORME SEIENT AVIÓ: ' + @codi 
    PRINT 'TIPUS' + REPLICATE(' ', 12) + 'FINESTRA' + REPLICATE(' ', 4) 
        + 'FILA'+REPLICATE(' ', 4) + 'COLUMNA'     +REPLICATE(' ', 4) + 'OCUPAT' 
END
GO
CREATE OR ALTER PROCEDURE pintaInformeAvio (@codi CHAR(8))
    WITH RECOMPILE AS
BEGIN
    IF(dbo.existeixAvio(@codi)=0) PRINT 'L''avió no existeix'
    ELSE IF(dbo.existeixSeient(@codi)>0) PRINT 'No hi ha seients creats'
    ELSE
    BEGIN
        DECLARE @fila TINYINT, @columna TINYINT, @finestra BIT, @ocupat BIT, @tipus CHAR(1)
        DECLARE @tipusText CHAR(20), @finestraText CHAR(10), @ocupatText CHAR(2)
        DECLARE cSeient CURSOR FOR SELECT fila, columna, finestra, ocupat, tipus FROM seient
                                WHERE avioCodi = @codi
        OPEN cSeient
        EXEC pintaCapcaleraAvio @codi
        FETCH NEXT FROM cSeient INTO @fila, @columna, @finestra, @ocupat, @tipus
        WHILE(@@FETCH_STATUS=0)
        BEGIN
            IF(@finestra=0) SET @finestraText = 'NO'
            ELSE SET @finestraText = 'SI'
            IF(@ocupat=0) SET @ocupatText = 'NO'
            ELSE SET @ocupatText = 'SI'
            IF(@tipus='P') SET @tipusText = 'Primera classe'
            ELSE SET @tipusText = 'Turista'

            PRINT @tipusText + @finestraText + CAST(@fila AS CHAR(10)) + CAST(@columna AS CHAR(10)) + @ocupatText
            FETCH NEXT FROM cSeient INTO @fila, @columna, @finestra, @ocupat, @tipus
        END
        CLOSE cSeient
        DEALLOCATE cSeient
    END
END
GO
EXEC pintaInformeAvio 'AIR003'
GO
/* EXERCICI 4.
Fer un cursor que ens retorni quin és el primer seient buit d’un determinat
avió donat un tipus. Cal fer servir un cursor per recórrer tots els registres de
la taula Seient de l’avió que passem.
El procediment serà de la següent forma:*/

SELECT * FROM seient
go

BEGIN
    DECLARE @fila INT
    DECLARE @columna INT
    DECLARE @tipus CHAR(1)
    EXEC primerSeientBuit 'AIR00003', @fila OUT, @columna OUT, @tipus

    IF @fila=-1 PRINT 'No hi ha cap seient lliure'
    ELSE PRINT 'El primer seient lliure es FILA: ' + CAST(@fila AS VARCHAR(2)) + ' - COLUMNA: ' + CAST(@columna AS VARCHAR(2))
END
GO

CREATE OR ALTER PROCEDURE primerSeientBuit (@codi VARCHAR(8),@fila INT OUT,@columna INT OUT, @tipus CHAR(1)) 
    WITH RECOMPILE AS
BEGIN
    IF dbo.existeixAvio(@codi) = 0 PRINT 'L''avió no existeix'
    ELSE IF dbo.existeixSeient(@codi) = 0 PRINT 'L''avió no te seients'
    ELSE 
    BEGIN
        DECLARE cSeient CURSOR FOR SELECT fila,columna,ocupat,tipus FROM seient
            WHERE avioCodi=@codi 
        DECLARE @ocupat BIT=0
        OPEN cSeient

        FETCH FROM cSeient INTO @fila,@columna,@ocupat,@tipus
        WHILE (@@FETCH_STATUS = 0 AND @ocupat =1)
        BEGIN
            FETCH NEXT FROM cSeient INTO @fila,@columna,@ocupat,@tipus
        END

        IF (@ocupat=1) SET @fila =-1
        CLOSE cSeient
        DEALLOCATE cSeient
    END
END
GO

/*EXERCICI 5.Crear un procediment que utilitzant un cursor, ompli el primer seient buit d’un
avió donat un tipus classe.*/
-- primerSeientBuit(@codi, @fila , @col , @tipus )
EXEC omplirPrimerSeientBuit 'AIR00003', 'T'
GO
CREATE OR ALTER PROCEDURE omplirPrimerSeientBuit(@codi CHAR(8), @tipus CHAR(2))
    WITH RECOMPILE AS
BEGIN
    DECLARE @fila TINYINT, @col TINYINT
    EXEC primerSeientBuit 'AIR00003', @fila OUT, @col OUT, @tipus
    
    IF(@fila IS NULL) PRINT 'No hi ha cap seient buit'
    ELSE
    BEGIN
        UPDATE seient SET ocupat = 1 WHERE avioCodi=@codi AND fila=@fila AND columna=@col
        PRINT 'El seient fila: ' + CAST(@fila AS CHAR(2)) + ' columna: ' + CAST(@col AS CHAR(2)) + ' ha estat ocupat.'
    END
END
GO

/* EXERCICI 6.
Crear una taula que ens emmagatzemi (codiAvio, fila, columna, finestra,
tipus), de tots els seients buits d’un avió. Cal definir un cursor per recórrer els
registres de l’avió amb els seient no ocupats*/


/*EXERCICI 7.Fer un procediment, que mostri visualment els seients de l’avió, on la X representa que el seient està ocupat i O, que està disponible.
Cal que es mostri de la següent manera:*/

/*EXERCICI 8. Cal crear un procediment que pugui retornar 2 seients buits consecutius
perquè dues persones puguin seure juntes. Han de ser junts un al costat de
l'altre.*/
