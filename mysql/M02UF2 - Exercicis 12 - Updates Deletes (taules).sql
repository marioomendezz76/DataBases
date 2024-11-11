DROP DATABASE IF EXISTS dml_ex12UpdatesDeletes;
CREATE DATABASE IF NOT EXISTS dml_ex12UpdatesDeletes;
USE dml_ex12UpdatesDeletes;

CREATE TABLE Conductor ( 
    DNI CHAR(9),
	nom VARCHAR(100) NOT NULL,
	telefon CHAR(9),
	PRIMARY KEY (dni)
);

CREATE TABLE Camio ( 
    matricula CHAR(7),
	tonatge DECIMAL(6,2) NOT NULL,
	consum DECIMAL(4,2) NOT NULL,  -- El consum és cada 100 km
	conductorDNI char(9),
	estat ENUM('A','B'),   -- A per actiu, B per baixa
	PRIMARY KEY (matricula),
	CONSTRAINT fk_camio_conductor FOREIGN KEY (conductorDNI) REFERENCES Conductor (DNI)
		ON UPDATE CASCADE ON DELETE RESTRICT
            
);

CREATE TABLE Ruta ( 
    codi CHAR(3),
	cpOrigen CHAR(5) NOT NULL,  
	cpDesti VARCHAR(5) NOT NULL,  
	PRIMARY KEY (codi)
);

CREATE TABLE Fa ( 
    camioMatricula CHAR(8),
	rutaCodi CHAR(3),
	data date NOT NULL,
	temps integer,   -- expressat en minuts
	PRIMARY KEY (camioMatricula, rutaCodi, data),
	CONSTRAINT fk_fa_ruta	FOREIGN KEY (rutaCodi) references Ruta (codi)
			ON DELETE RESTRICT 	ON UPDATE RESTRICT,
	CONSTRAINT fk_fa_camio	FOREIGN KEY (camioMatricula) references Camio (matricula)
			ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Trams ( 
    puntKilom DECIMAL(3,1) ,
	cost_peatge DECIMAL(4,2), 
    distancia DECIMAL(3,1),
	rutaCodi CHAR(3),
	PRIMARY KEY (rutaCodi,puntKilom),
    CONSTRAINT fk_trams_ruta FOREIGN KEY (rutaCodi) REFERENCES Ruta (codi)
			ON UPDATE CASCADE ON DELETE RESTRICT
);


-- ******************************* DADES **************************************

INSERT INTO conductor VALUES ('12345678A', 'María López García', '555123456'),
                              ('23456789B', 'Juan Martínez Rodríguez', '555234567'),
                              ('34567890C', 'Ana Rodríguez Pérez', '555345678'),
                              ('45678901D', 'Javier Fernández Martínez', '555456789'),
                              ('56789012E', 'Carmen González López', '555567890'),
                              ('67890123F', 'Pedro Sánchez Ruiz', '555678901'),
                              ('78901234G', 'Laura González Martínez', '555789012'),
                              ('89012345H', 'Alejandro Pérez García', '555890123'),
                              ('90123456J', 'Isabel Martínez López', '555901234'),
                              ('01234567K', 'Francisco García Rodríguez', '555012345'),
                              ('12345678L', 'Lucía Rodríguez Sánchez', '555123456'),
                              ('23456789M', 'Alberto López Pérez', '555234567'),
                              ('34567890N', 'Marta Sánchez Martínez', '555345678'),
                              ('45678901P', 'Carlos Martínez Rodríguez', '555456789'),
                              ('56789012Q', 'Elena Rodríguez López', '555567890');

INSERT INTO Camio VALUES ('0002AAA', 1000, 25.50, '67890123F', 'A'),('0002BBB', 700, 35.80, '78901234G', 'A'),
                          ('0002CCC', 1500, 18.75, '89012345H', 'B'),('0002DDD', 300, 14.20, '90123456J', 'A'),
                          ('9002EEE', 550, 28.75, '01234567K', 'B'),('0002FFF', 1500, 32.40, '12345678L', 'A'),
                          ('0002GGG', 4000, 20.10, '23456789M', 'A'),('0002HHH', 1050, 20.10, '34567890N', 'A'),
                          ('0002III', 350, 16.80, '45678901P', 'B'),('0002JJJ', 2000, 30.50, '56789012Q', 'A'),
                          ('0003III', 350, 16.80, '45678901P', 'B'),('0004JJJ', 2000, 30.50, '56789012Q', 'A'),
                          ('0002EEE', 550, 28.75, '01234567K', 'B'),('0102FFF', 1500, 32.40, '12345678L', 'A'),
                          ('0302EEE', 550, 28.75, '01234567K', 'B'),('0104FFF', 1500, 32.40, '12345678L', 'A');

INSERT INTO ruta VALUES ('R01','00001','00010'),('R02','00002','00020'),('R03','00003','00030'),
						('R04','00005','00030'), ('R07', '00007', '00025'),('R08', '00008', '00035'),
                        ('R09', '00009', '00040'),('R10', '00010', '00015'),('R11', '00011', '00030');

INSERT INTO Fa VALUES ('0002AAA', 'R07', '2022-03-15', 60),('0002BBB', 'R08', NOW(), 90),
                     ('0002CCC', 'R09', NOW(), 120),('0002DDD', 'R10', '2022-02-20', 45),
                     ('0002EEE', 'R11', '2022-01-10', 75),('0002FFF', 'R07', NOW(), 120),
                     ('0002GGG', 'R08', '2022-03-01', 80),('0002HHH', 'R09', NOW(), 110),
                     ('0002III', 'R10', '2022-02-10', 60),('0002JJJ', 'R11', '2022-01-25', 95),
                     ('0002AAA', 'R07', '2022-02-05', 100),('0002BBB', 'R08', '2022-02-06', 70),
                     ('0002CCC', 'R09', '2023-02-06', 130),('0002DDD', 'R10', '2022-01-15', 55),
                     ('0002EEE', 'R11', '2022-02-28', 85);
     
                    
INSERT INTO Trams VALUES (0,0,30,'R01'), (30,5,10,'R01'),(40,8.25,50,'R01'),
						(0,0,20,'R02'),(20,1,30,'R02'),(50,0,30,'R02'),(80,12,60,'R02'),
                        (0,10,90,'R03'), (95,4,5,'R03'),(1,0,15,'R04'),(16,2,12,'R04'),(29,0,50,'R04');

INSERT INTO Trams VALUES (20, 6.75, 25, 'R07'), (30, 8.50, 30, 'R07'),(5, 1.25, 15, 'R08'), (15, 3.75, 20, 'R08'),
                         (25, 5.25, 35, 'R09'), (10, 2.50, 18, 'R09'),(40, 10.25, 45, 'R10'), (15, 4.50, 22, 'R10'),
                         (5, 1.75, 12, 'R11'), (20, 6.00, 28, 'R11'),(10, 3.25, 15, 'R07'), (35, 12.50, 40, 'R07'),
                         (18, 4.75, 28, 'R08'), (8, 2.00, 10, 'R08'),(30, 9.75, 38, 'R09'), (12, 3.00, 20, 'R09'),
                         (50, 15.25, 55, 'R10'), (22, 6.50, 32, 'R10'),(8, 2.25, 14, 'R11'), (25, 7.50, 42, 'R11');


        