DROP DATABASE if exists dml_ex13_UpdateDelete;
CREATE DATABASE if not exists dml_ex13_UpdateDelete;
USE dml_ex13_UpdateDelete;

CREATE TABLE IF NOT EXISTS Genere (
	codi CHAR(8),
    nom VARCHAR(20),
	PRIMARY KEY (codi)
);

CREATE TABLE IF NOT EXISTS Soci (
	codi CHAR(8),
    dni char(9) UNIQUE,
    nom VARCHAR(50) NOT NULL,
    PRIMARY KEY (codi)
) ;

CREATE TABLE IF NOT EXISTS Llibre(
	isbn CHAR(13),
    titol VARCHAR(100),
    totalExemplars INT,
    genereCodi CHAR(8),
    PRIMARY KEY (isbn),
    CONSTRAINT fk_llibre_genere	FOREIGN KEY (genereCodi) REFERENCES Genere(codi)
			ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Prestec(
	llibreISBN CHAR(13),
    sociCodi CHAR(8),
    dataprestec DATE not null, 
    dataretorn DATE,
    dataretornteorica DATE,
    numprorog INT,
    PRIMARY KEY (llibreIsbn,sociCodi,dataprestec),
    CONSTRAINT fk_prestec_llibre FOREIGN KEY (llibreIsbn) REFERENCES Llibre(isbn)
			ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT fk_prestec_soci FOREIGN KEY (sociCodi) REFERENCES Soci(codi)
			ON UPDATE RESTRICT ON DELETE RESTRICT
);

INSERT INTO Genere (codi, nom) VALUES ('GEN001', 'Ficció'),('GEN002', 'No ficció'),('GEN003', 'Misteri'),
					('GEN004', 'Ciència-ficció'),('GEN005', 'Biografia'),('GEN006', 'Fantasia');


INSERT INTO Soci (codi, dni, nom) VALUES
('SOC00601', '13579246A', 'Carla López Sánchez'),('SOC00702', '24681357F', 'Marc Martínez García'),
('SOC00803', '98765432A', 'Laura Sánchez Martínez'),('SOC00904', '45612378C', 'David García López'),
('SOC01005', '98765432M', 'Marta Pérez Gómez'),('SOC01106', '15935724Q', 'Sergio Rodríguez Pérez'),
('SOC01207', '36925814K', 'Elena Martínez Sánchez'),('SOC01308', '75395185Z', 'Javier Ruiz Gómez'),
('SOC01409', '85236974S', 'Sara Gómez Rodríguez'),('SOC01510', '951357482', 'Pablo Fernández Martínez');


INSERT INTO Llibre (isbn, titol, totalExemplars, genereCodi) VALUES
('9780061120084', 'Harry Potter i la pedra filosofal', 50, 'GEN006'),('9788498386264', 'El codi Da Vinci', 30, 'GEN001'),
('9780345339683', 'El Senyor dels Anells', 40, 'GEN006'),('9780671722626', '1984', 25, 'GEN004'),
('9780380014300', 'Matar un rossinyol', 35, 'GEN002');

INSERT INTO Llibre (isbn, titol, totalExemplars, genereCodi) VALUES
('9788408218575', 'El laberinto de los espíritus', 20, 'GEN006'),('9788423354278', 'Origen', 15, 'GEN001'),
('9788408179356', 'El tiempo entre costuras', 30, 'GEN005'),('9788408130814', 'El nombre del viento', 25, 'GEN006'),
('9788401021044', 'La sombra del viento', 35, 'GEN006');

INSERT INTO Llibre (isbn, titol, totalExemplars, genereCodi) VALUES
('9788466348695', 'Reina roja', 40, 'GEN003'),('9788408217523', 'La chica del tren', 25, 'GEN003'),
('9788423350843', 'El alquimista', 30, 'GEN005'),('9788408003544', 'Los pilares de la Tierra', 20, 'GEN005'),
('9788408034067', 'El juego del ángel', 15, 'GEN006'),('9788408157434', 'La catedral del mar', 35, 'GEN005'),
('9788420423925', 'El prisionero del cielo', 30, 'GEN006');

INSERT INTO Prestec (llibreISBN, sociCodi, dataprestec, dataretorn, dataretornteorica, numprorog) VALUES
('9780061120084', 'SOC00601', '2024-01-15', '2024-02-05', '2024-02-01', 1),
('9788498386264', 'SOC00702', '2024-01-20', '2024-02-10', '2024-02-05', 0),
('9780345339683', 'SOC00803', '2024-01-25', '2024-02-15', '2024-02-10', 2),
('9780671722626', 'SOC00904', '2024-01-30', NULL, '2024-02-15', 0),
('9780380014300', 'SOC01005', '2024-02-05', NULL, '2024-02-20', 0),
('9788408218575', 'SOC01106', '2024-02-10', NULL, '2024-02-25', 0),
('9788423354278', 'SOC01207', '2024-02-15', NULL, '2024-03-01', 0),
('9788408179356', 'SOC01308', '2024-02-20', NULL, '2024-03-05', 0),
('9788408130814', 'SOC01409', '2024-02-25', NULL, '2024-03-10', 0),
('9788401021044', 'SOC01510', '2024-03-01', NULL, '2024-03-15', 0);

INSERT INTO Prestec (llibreISBN, sociCodi, dataprestec, dataretorn, dataretornteorica, numprorog) VALUES
('9780061120084', 'SOC00601', '2024-01-14', '2024-02-05', '2024-02-01', 1),
('9788498386264', 'SOC00702', '2024-01-26', '2024-02-10', '2024-02-05', 0),
('9780345339683', 'SOC00803', '2024-01-12', '2024-02-15', '2024-02-10', 2),
('9780671722626', 'SOC00904', '2024-01-31', NULL, '2024-02-15', 0),
('9788401021044', 'SOC01005', '2024-02-05', NULL, '2024-02-20', 0),
('9788408003544', 'SOC00601', '2024-02-10', NULL, '2024-02-25', 0),
('9788408003544', 'SOC00702', '2024-02-15', NULL, '2024-03-01', 0),
('9788408179356', 'SOC00803', '2024-02-21', NULL, '2024-03-05', 0),
('9788408003544', 'SOC00904', '2024-02-25', NULL, '2024-03-10', 0),
('9788401021044', 'SOC01005', '2024-03-01', NULL, '2024-03-15', 0);

