-- Eliminar la base de datos 'proyecto' si existe
DROP DATABASE IF EXISTS proyecto;

-- Crear la base de datos 'proyecto'
CREATE DATABASE proyecto;

-- Usar la base de datos 'proyecto'
\c proyecto;

CREATE TABLE Especialidad (
    ID_Especialidad serial PRIMARY KEY,
    Nombre varchar(50) NOT NULL,
    Descripcion varchar(100) NOT NULL,
    Disponible boolean NOT NULL
);

CREATE TABLE Doctor (
    ID_Doctor serial PRIMARY KEY,
    Nombre varchar(70) NOT NULL,
    Apellido varchar(70) NOT NULL,
    Colegiado int NOT NULL,
    Disponible boolean NOT NULL,
    FK_ID_Especialidad int NOT NULL,
    CONSTRAINT FK_ID_Especialidad FOREIGN KEY (FK_ID_Especialidad)
        REFERENCES Especialidad (ID_Especialidad) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Medicina (
    ID_Medicina serial PRIMARY KEY,
    Nombre varchar(100) NOT NULL,
    Perecedero boolean NOT NULL,
    Fecha_Ingreso timestamp NOT NULL,
    Fecha_Lote timestamp NOT NULL,
    Fecha_Caducidad timestamp,
    Casa varchar(100) NOT NULL,
    TipoMedicamento varchar(50) NOT NULL,
    Descripcion varchar(255),
    Imagen text
);

CREATE TABLE Paciente (
    ID serial PRIMARY KEY,
    Identificador char(30) NOT NULL,
    Nombre varchar(70) NOT NULL,
    Apellido varchar(70) NOT NULL,
    Residencia varchar(70) NOT NULL,
    Contacto int NOT NULL,
    Estado varchar(100) NOT NULL,
    AltaBaja boolean NOT NULL,
    Edad int NOT NULL,
    Visitas int NOT NULL
);

CREATE TABLE Tipo_Usuario (
    ID_TipoUsuario serial PRIMARY KEY,
    Nombre char(50),
    ModuloPaciente boolean NOT NULL,
    ModuloDoctor boolean NOT NULL,
    ModuloMedicina boolean NOT NULL,
    ModuloReporte boolean NOT NULL
);

CREATE TABLE Usuario (
    Usuario varchar(75) PRIMARY KEY,
    Contrasena char(30) NOT NULL,
    ActivoInactivo boolean NOT NULL,
    FK_ID_TipoUsuario int NOT NULL,
    CONSTRAINT FK_ID_TipoUsuario FOREIGN KEY (FK_ID_TipoUsuario)
        REFERENCES Tipo_Usuario (ID_TipoUsuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Historial_Paciente (
    FK_ID_Paciente int NOT NULL,
    FK_ID_Doctor int NOT NULL,
    FechaIngreso timestamp NOT NULL,
    FechaSalida timestamp NOT NULL,
    Accidente boolean NOT NULL,
    Enfermedad boolean NOT NULL,
    CONSTRAINT FK_ID_Paciente FOREIGN KEY (FK_ID_Paciente)
        REFERENCES Paciente (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_ID_Doctor FOREIGN KEY (FK_ID_Doctor)
        REFERENCES Doctor (ID_Doctor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Receta (
    ID_Receta serial PRIMARY KEY,
    FK_ID_Doctor1 int NOT NULL,
    FK_ID_Medicina int NOT NULL,
    FK_ID_Paciente1 int NOT NULL,
    FechaReceta timestamp NOT NULL,
    CONSTRAINT FK_ID_Doctor1 FOREIGN KEY (FK_ID_Doctor1)
        REFERENCES Doctor (ID_Doctor) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_ID_Medicina FOREIGN KEY (FK_ID_Medicina)
        REFERENCES Medicina (ID_Medicina) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_ID_Paciente1 FOREIGN KEY (FK_ID_Paciente1)
        REFERENCES Paciente (ID) ON DELETE CASCADE ON UPDATE CASCADE
);



----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
-- Procedimientos almacenados en PostgreSQL

-- createEspecialidad
CREATE OR REPLACE PROCEDURE createEspecialidad(
    IN p_Nombre varchar(50),
    IN p_Descripcion varchar(100),
    IN p_Disponible boolean
)
AS $$
BEGIN
    INSERT INTO Especialidad (Nombre, Descripcion, Disponible) VALUES (p_Nombre, p_Descripcion, p_Disponible);
END;
$$ LANGUAGE plpgsql;

-- createDoctor
CREATE OR REPLACE PROCEDURE createDoctor(
    IN p_Nombre varchar(70),
    IN p_Apellido varchar(70),
    IN p_Colegiado int,
    IN p_Disponible boolean,
    IN p_FK_ID_Especialidad int
)
AS $$
BEGIN
    INSERT INTO Doctor (Nombre, Apellido, Colegiado, Disponible, FK_ID_Especialidad)
    VALUES (p_Nombre, p_Apellido, p_Colegiado, p_Disponible, p_FK_ID_Especialidad);
END;
$$ LANGUAGE plpgsql;

-- createMedicina
CREATE OR REPLACE PROCEDURE createMedicina(
    IN p_Nombre varchar(100),
    IN p_Perecedero boolean,
    IN p_Fecha_Ingreso timestamp,
    IN p_Fecha_Lote timestamp,
    IN p_Fecha_Caducidad timestamp,
    IN p_Casa varchar(100),
    IN p_TipoMedicamento varchar(50),
    IN p_Descripcion varchar(255),
    IN p_Imagen text
)
AS $$
BEGIN
    IF p_Perecedero THEN
        INSERT INTO Medicina (Nombre, Perecedero, Fecha_Ingreso, Fecha_Lote, Fecha_Caducidad, Casa, TipoMedicamento, Descripcion, Imagen)
        VALUES (p_Nombre, p_Perecedero, p_Fecha_Ingreso, p_Fecha_Lote, p_Fecha_Caducidad, p_Casa, p_TipoMedicamento, p_Descripcion, p_Imagen);
    ELSE
        INSERT INTO Medicina (Nombre, Perecedero, Fecha_Ingreso, Fecha_Lote, Casa, TipoMedicamento, Descripcion, Imagen)
        VALUES (p_Nombre, p_Perecedero, p_Fecha_Ingreso, p_Fecha_Lote, p_Casa, p_TipoMedicamento, p_Descripcion, p_Imagen);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- createPaciente
CREATE OR REPLACE PROCEDURE createPaciente(
    IN p_Nombre varchar(70),
    IN p_Apellido varchar(70),
    IN p_Residencia varchar(70),
    IN p_Contacto int,
    IN p_Estado varchar(100),
    IN p_AltaBaja boolean,
    IN p_Edad int
)
AS $$
DECLARE
    v_anio char(4);
    v_idtmp int;
    v_Idt char(4);
    v_Identificador char(30);
BEGIN
    v_anio := to_char(CURRENT_DATE, 'YYYY');
    SELECT COALESCE(MAX(ID), 0) INTO v_idtmp FROM Paciente;
    v_idtmp := v_idtmp + 1;
    v_Idt := to_char(v_idtmp, 'FM0000');
    v_Identificador := v_Idt || v_anio;
    
    INSERT INTO Paciente (ID, Identificador, Nombre, Apellido, Residencia, Contacto, Estado, AltaBaja, Edad, Visitas)
    VALUES (v_idtmp, v_Identificador, p_Nombre, p_Apellido, p_Residencia, p_Contacto, p_Estado, p_AltaBaja, p_Edad, 1);
END;
$$ LANGUAGE plpgsql;

-- createTipo_Usuario
CREATE OR REPLACE PROCEDURE createTipo_Usuario(
    IN p_Nombre char(50),
    IN p_ModuloPaciente boolean,
    IN p_ModuloDoctor boolean,
    IN p_ModuloMedicina boolean,
    IN p_ModuloReporte boolean
)
AS $$
BEGIN
    INSERT INTO Tipo_Usuario (Nombre, ModuloPaciente, ModuloDoctor, ModuloMedicina, ModuloReporte)
    VALUES (p_Nombre, p_ModuloPaciente, p_ModuloDoctor, p_ModuloMedicina, p_ModuloReporte);
END;
$$ LANGUAGE plpgsql;

-- createUsuario
CREATE OR REPLACE PROCEDURE createUsuario(
    IN p_Usuario varchar(75),
    IN p_Contrasena char(30),
    IN p_ActivoInactivo boolean,
    IN p_TipoUsuario int
)
AS $$
BEGIN
    INSERT INTO Usuario (Usuario, Contrasena, ActivoInactivo, FK_ID_TipoUsuario)
    VALUES (p_Usuario, p_Contrasena, p_ActivoInactivo, p_TipoUsuario);
END;
$$ LANGUAGE plpgsql;

-- createHistorial_Paciente
CREATE OR REPLACE PROCEDURE createHistorial_Paciente(
    IN p_FK_ID_Paciente int,
    IN p_FK_ID_Doctor int,
    IN p_FechaIngreso timestamp,
    IN p_FechaSalida timestamp,
    IN p_Accidente boolean,
    IN p_Enfermedad boolean
)
AS $$
DECLARE
    v_visitas int;
BEGIN
    SELECT Visitas INTO v_visitas FROM Paciente WHERE ID = p_FK_ID_Paciente;
    v_visitas := v_visitas + 1;
    
    INSERT INTO Historial_Paciente (FK_ID_Paciente, FK_ID_Doctor, FechaIngreso, FechaSalida, Accidente, Enfermedad)
    VALUES (p_FK_ID_Paciente, p_FK_ID_Doctor, p_FechaIngreso, p_FechaSalida, p_Accidente, p_Enfermedad);
    
    UPDATE Paciente SET Visitas = v_visitas WHERE ID = p_FK_ID_Paciente;
END;
$$ LANGUAGE plpgsql;

-- createReceta
CREATE OR REPLACE PROCEDURE createReceta(
    IN p_FK_ID_Doctor int,
    IN p_FK_ID_Medicina int,
    IN p_FK_ID_Persona int,
    IN p_FechaReceta timestamp
)
AS $$
BEGIN
    INSERT INTO Receta (FK_ID_Doctor, FK_ID_Medicina, FK_ID_Persona, FechaReceta)
    VALUES (p_FK_ID_Doctor, p_FK_ID_Medicina, p_FK_ID_Persona, p_FechaReceta);
END;
$$ LANGUAGE plpgsql;

----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
-- Procedimientos almacenados "Read" en PostgreSQL

-- readEspecialidad
CREATE OR REPLACE PROCEDURE readEspecialidad()
AS $$
BEGIN
    SELECT * FROM Especialidad;
END;
$$ LANGUAGE plpgsql;

-- readDoctor
CREATE OR REPLACE PROCEDURE readDoctor()
AS $$
BEGIN
    SELECT D.Nombre, D.Apellido, D.Colegiado, D.Disponible, E.Nombre, E.Descripcion
    FROM Doctor AS D
    INNER JOIN Especialidad AS E ON E.ID_Especialidad = D.FK_ID_Especialidad;
END;
$$ LANGUAGE plpgsql;

-- readMedicina
CREATE OR REPLACE PROCEDURE readMedicina()
AS $$
BEGIN
    SELECT ID_Medicina, Nombre, Perecedero,
           TO_CHAR(Fecha_Ingreso, 'DD/MM/YYYY') AS Fecha_Ingreso,
           TO_CHAR(Fecha_Lote, 'DD/MM/YYYY') AS Fecha_Lote,
           TO_CHAR(Fecha_Caducidad, 'DD/MM/YYYY') AS Fecha_Caducidad,
           Casa, TipoMedicamento, Imagen
    FROM Medicina;
END;
$$ LANGUAGE plpgsql;

-- readTipo_usuario
CREATE OR REPLACE PROCEDURE readTipo_usuario()
AS $$
BEGIN
    SELECT * FROM Tipo_Usuario;
END;
$$ LANGUAGE plpgsql;

-- readUsuario
CREATE OR REPLACE PROCEDURE readUsuario()
AS $$
BEGIN
    SELECT * FROM Usuario;
END;
$$ LANGUAGE plpgsql;

-- readPaciente
CREATE OR REPLACE PROCEDURE readPaciente()
AS $$
BEGIN
    SELECT * FROM Paciente;
END;
$$ LANGUAGE plpgsql;

-- readReceta
CREATE OR REPLACE PROCEDURE readReceta(IN p_ID int)
AS $$
BEGIN
    IF p_ID > 0 THEN
        SELECT R.ID_Receta, R.FechaReceta,
               P.Identificador, P.Nombre, P.Apellido,
               D.Colegiado, D.Nombre, D.Apellido,
               M.ID_Medicina, M.Nombre, M.Casa, M.TipoMedicamento
        FROM Receta AS R
        INNER JOIN Paciente AS P ON P.ID = R.FK_ID_Paciente1
        INNER JOIN Doctor AS D ON D.ID_Doctor = R.FK_ID_Doctor1
        INNER JOIN Medicina AS M ON M.ID_Medicina = R.FK_ID_Medicina
        WHERE ID_Receta = p_ID;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- recetaTotal
CREATE OR REPLACE PROCEDURE recetaTotal()
AS $$
BEGIN
    SELECT R.ID_Receta, R.FechaReceta,
           P.Identificador, P.Nombre, P.Apellido,
           D.Colegiado, D.Nombre, D.Apellido,
           M.ID_Medicina, M.Nombre, M.Casa, M.TipoMedicamento
    FROM Receta AS R
    INNER JOIN Paciente AS P ON P.ID = R.FK_ID_Paciente1
    INNER JOIN Doctor AS D ON D.ID_Doctor = R.FK_ID_Doctor1
    INNER JOIN Medicina AS M ON M.ID_Medicina = R.FK_ID_Medicina;
END;
$$ LANGUAGE plpgsql;


----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
-- Procedimientos almacenados "Update" en PostgreSQL

-- updateEspecialidad
CREATE OR REPLACE PROCEDURE updateEspecialidad(
    IN p_ID_Especialidad int,
    IN p_Nombre varchar(50),
    IN p_Descripcion varchar(100)
)
AS $$
BEGIN
    UPDATE Especialidad
    SET Nombre = p_Nombre, Descripcion = p_Descripcion
    WHERE ID_Especialida = p_ID_Especialidad;
END;
$$ LANGUAGE plpgsql;

-- updateDoctor
CREATE OR REPLACE PROCEDURE updateDoctor(
    IN p_ID_Doctor int,
    IN p_Nombre varchar(70),
    IN p_Apellido varchar(70),
    IN p_Colegiado int,
    IN p_FK_ID_Especialidad int
)
AS $$
BEGIN
    UPDATE Doctor
    SET Nombre = p_Nombre, Apellido = p_Apellido
    WHERE ID_Doctor = p_ID_Doctor;
END;
$$ LANGUAGE plpgsql;

-- updateMedicina
CREATE OR REPLACE PROCEDURE updateMedicina(
    IN p_ID_Medicina int,
    IN p_Nombre varchar(100),
    IN p_Perecedero boolean,
    IN p_Fecha_Ingreso timestamp,
    IN p_Fecha_Lote timestamp,
    IN p_Fecha_Caducidad timestamp,
    IN p_Casa varchar(100),
    IN p_TipoMedicamento varchar(50)
)
AS $$
BEGIN
    IF p_Perecedero = 1 THEN
        UPDATE Medicina
        SET Nombre = p_Nombre, Perecedero = p_Perecedero,
            Fecha_Ingreso = p_Fecha_Ingreso, Fecha_Lote = p_Fecha_Lote,
            Fecha_Caducidad = p_Fecha_Caducidad, Casa = p_Casa,
            TipoMedicamento = p_TipoMedicamento
        WHERE ID_Medicina = p_ID_Medicina;
    ELSIF p_Perecedero = 0 THEN
        UPDATE Medicina
        SET Nombre = p_Nombre, Perecedero = p_Perecedero,
            Fecha_Ingreso = p_Fecha_Ingreso, Fecha_Lote = p_Fecha_Lote,
            Fecha_Caducidad = NULL, Casa = p_Casa,
            TipoMedicamento = p_TipoMedicamento
        WHERE ID_Medicina = p_ID_Medicina;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- updatePaciente
CREATE OR REPLACE PROCEDURE updatePaciente(
    IN p_Identificador char(30),
    IN p_Nombre varchar(70),
    IN p_Apellido varchar(70),
    IN p_Residencia varchar(70),
    IN p_Contacto int,
    IN p_Estado varchar(100),
    IN p_Edad int,
    IN p_Visitas int
)
AS $$
BEGIN
    UPDATE Paciente
    SET Nombre = p_Nombre, Apellido = p_Apellido,
        Residencia = p_Residencia, Contacto = p_Contacto,
        Estado = p_Estado, Edad = p_Edad, Visitas = p_Visitas
    WHERE Identificador = p_Identificador;
END;
$$ LANGUAGE plpgsql;

-- updateTipo_Usuario
CREATE OR REPLACE PROCEDURE updateTipo_Usuario(
    IN p_ID_TipoUsuario int,
    IN p_Nombre char(50),
    IN p_ModuloPaciente boolean,
    IN p_ModuloDoctor boolean,
    IN p_ModuloMedicina boolean,
    IN p_ModuloReporte boolean
)
AS $$
BEGIN
    UPDATE Tipo_Usuario
    SET Nombre = p_Nombre, ModuloPaciente = p_ModuloPaciente,
        ModuloDoctor = p_ModuloDoctor, ModuloMedicina = p_ModuloMedicina,
        ModuloReporte = p_ModuloReporte
    WHERE ID_TipoUsuario = p_ID_TipoUsuario;
END;
$$ LANGUAGE plpgsql;

-- updateUsuario
CREATE OR REPLACE PROCEDURE updateUsuario(
    IN p_Usuario varchar(75),
    IN p_Contrasena char(30),
    IN p_ActivoInactivo boolean,
    IN p_FK_ID_TipoUsuario int
)
AS $$
BEGIN
    UPDATE Usuario
    SET Contrasena = p_Contrasena, ActivoInactivo = p_ActivoInactivo,
        FK_ID_TipoUsuario = p_FK_ID_TipoUsuario
    WHERE Usuario = p_Usuario;
END;
$$ LANGUAGE plpgsql;


----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
-- Procedimientos almacenados "Delete" en PostgreSQL

-- deleteEspecialidad
CREATE OR REPLACE PROCEDURE deleteEspecialidad(
    IN p_ID_Especialidad int,
    IN p_Disponible boolean
)
AS $$
BEGIN
    UPDATE Especialidad
    SET Disponible = p_Disponible
    WHERE ID_Especialida = p_ID_Especialidad;
END;
$$ LANGUAGE plpgsql;

-- deleteDoctor
CREATE OR REPLACE PROCEDURE deleteDoctor(
    IN p_ID_Doctor varchar(45),
    IN p_Disponible boolean
)
AS $$
BEGIN
    UPDATE Doctor
    SET Disponible = p_Disponible
    WHERE Apellido = p_ID_Doctor;
END;
$$ LANGUAGE plpgsql;

-- deletePaciente
CREATE OR REPLACE PROCEDURE deletePaciente(
    IN p_Identificador char(30),
    IN p_AltaBaja boolean
)
AS $$
BEGIN
    UPDATE Paciente
    SET AltaBaja = p_AltaBaja
    WHERE Nombre = p_Identificador;
END;
$$ LANGUAGE plpgsql;

-- deleteUsuario
CREATE OR REPLACE PROCEDURE deleteUsuario(
    IN p_ID_Usuario varchar(45),
    IN p_ActivoInactivo boolean
)
AS $$
BEGIN
    UPDATE Usuario
    SET ActivoInactivo = p_ActivoInactivo
    WHERE Usuario = p_ID_Usuario;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento "historial"
CREATE OR REPLACE PROCEDURE historial(
    IN p_ID int
)
AS $$
BEGIN
    SELECT p.Nombre, p.Apellido, p.Estado, p.Contacto, p.Edad, p.AltaBaja,
           D.Nombre, D.Apellido, D.Colegiado, FechaIngreso, FechaSalida, Enfermedad, Accidente
    FROM Historial_Paciente AS hp
    INNER JOIN Doctor AS D ON D.ID_Doctor = hp.FK_ID_Doctor
    INNER JOIN Paciente AS p ON p.ID = hp.FK_ID_Paciente
    WHERE hp.FK_ID_Paciente = p_ID;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento "historialTotal"
CREATE OR REPLACE PROCEDURE historialTotal()
AS $$
BEGIN
    SELECT p.Nombre, p.Apellido, p.Estado, p.Contacto, p.Edad, p.AltaBaja,
           D.Nombre, D.Apellido, D.Colegiado, FechaIngreso, FechaSalida, Enfermedad, Accidente
    FROM Historial_Paciente AS hp
    INNER JOIN Doctor AS D ON D.ID_Doctor = hp.FK_ID_Doctor
    INNER JOIN Paciente AS p ON p.ID = hp.FK_ID_Paciente;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento "corroborarUC" (login)
CREATE OR REPLACE PROCEDURE corroborarUC(
    IN p_Usuario char(30),
    IN p_Contrasena char(30)
)
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Usuario
        WHERE Usuario = p_Usuario AND Contrasena = p_Contrasena
    ) THEN
        SELECT
            1,
            TU.Nombre,
            TU.ModuloPaciente,
            TU.ModuloDoctor,
            TU.ModuloMedicina,
            TU.ModuloReporte
        FROM Usuario AS Us
        INNER JOIN Tipo_Usuario AS TU ON TU.ID_TipoUsuario = Us.FK_ID_TipoUsuario
        WHERE Usuario = p_Usuario AND Contrasena = p_Contrasena;
    ELSE
        SELECT 0;
    END IF;
END;
$$ LANGUAGE plpgsql;


select readPaciente()
select createPaciente('Victor','Guerra','guate',32656578,'vivo',1,22) 
select createPaciente('Kevin','Illu','zacapa',32456000,'golpeado',1,20) 
select createPaciente('Jhonatan','Solares','puerto rico',42476578,'raspado',1,19) 
select createPaciente('Edgar','Oliva','miami',37777778,'dolor abdominal',1,32) 
select createPaciente('Erick','Tellez','EEUU',30000008,'dolor de espalda',1,26) 
select createPaciente('Donald','Tellez Olvia','New York',30001100,'dolor de rodilla',1,27) 

select readEspecialidad()

select createEspecialidad ('Otorinoralingolo','revisa nariz y esas cosas',1)
select createEspecialidad ('Anastesiologia','Anestesia a la vieja escuela',1)
select createEspecialidad ('Cardiologia','atender la patolog�a y procedimientos cardiol�gicos en pacientes adultos y pedi�tricos',1)
select createEspecialidad ('Dermatologia','aplicar� la terap�utica espec�fica,para la piel',1)
select createEspecialidad ('Hematolog�a','valorara en forma integral a los pacientes adultos con problemas hematologicos',1)
select createEspecialidad ('Nefrologia','diagn�stico y tratamiento de las enfermedades renales,equilibrio hidro-eletrolitico y �cido b�sico',1)


select readDoctor()

select createDoctor ('DR. Mau','Ricio',1231,1,1)
select createDoctor ('DR. Dog','Chau',1232,1,2)
select createDoctor ('DR. Mario','Marito',1233,1,3)
select createDoctor ('DR. Cat','Odo',1234,1,4)
select createDoctor ('DR. An','Odo',1235,1,5)
select createDoctor ('DR. Rey','Ciceron',1236,1,6)

select ID_Especialida as value, Nombre as label from Especialidad


select readMedicina

select createMedicina ('GastroInter3000',1,'2022-10-11','2022-09-16','2022-01-01','Bayer','Digestivo','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');
select createMedicina ('Complejo B',0,'2022-10-12','2022-09-15','2022-02-01','ByB','Nervioso','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');
select createMedicina ('Cardio Aspirina',1,'2022-10-13','2022-09-14','2022-03-01','Faenco','Cardiologico','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');
select createMedicina ('Vitamina C',0,'2022-10-14','2022-09-13','2022-04-01','Logitech','Vitaminas','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');
select createMedicina ('Parecetamol (La vieja confiable)',1,'2022-10-15','2022-09-12','2022-05-01','MSI','Analgesicos','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');
select createMedicina ('Te Natural',0,'2022-10-16','2022-09-11','2022-06-01','SyS','Natural','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');
select createMedicina ('otra prueba',1,'2022-10-16','2022-09-11','2022-06-01','miau','cardiologo','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==');

select createReceta (1,1,1,'2022-10-23')
select createReceta (2,2,2,'2022-10-22')
select createReceta (3,3,3,'2022-10-21')
select createReceta (4,4,4,'2022-10-24')
select createReceta (5,5,5,'2022-10-25')
select createReceta (6,6,5,'2022-10-26')

select readReceta 1
select recetaTotal

select createHistorial_Paciente (1,1,'2022-10-23','2022-10-23',1,0)
select createHistorial_Paciente (2,2,'2022-10-23','2022-10-23',0,1)
select createHistorial_Paciente (3,3,'2022-10-23','2022-10-23',1,0)
select createHistorial_Paciente (4,4,'2022-10-23','2022-10-23',0,1)
select createHistorial_Paciente (5,5,'2022-10-23','2022-10-23',1,0)
select createHistorial_Paciente (6,6,'2022-10-23','2022-10-23',0,1)
select createHistorial_Paciente (5,5,'2022-10-22','2022-10-23',1,0)
select createHistorial_Paciente (6,6,'2022-10-22','2022-10-23',1,1)


select createTipo_Usuario ('Administrado',1,1,1,1)
select createTipo_Usuario ('Operador',1,1,1,0)
select createTipo_Usuario ('Consulta',1,0,0,0)
select createTipo_Usuario ('reportes',0,0,0,1)

select createUsuario ('hugo','abcdef',1,1)
select createUsuario ('vito','4125',1,2)
select createUsuario ('erick','4125',1,1)
select createUsuario ('edgar','4125',1,3)



-- reporte1
CREATE OR REPLACE FUNCTION reporte1()
RETURNS TABLE (
    /* Define aquí las columnas de la tabla */
) AS $$
BEGIN
    RETURN QUERY (
        SELECT *
        FROM Paciente
        ORDER BY visitas DESC
        LIMIT 3
    );
END;
$$ LANGUAGE plpgsql;

-- reporte2
CREATE OR REPLACE FUNCTION reporte2()
RETURNS TABLE (
    Enfermos INT,
    Accidentados INT
) AS $$
BEGIN
    SELECT COUNT(1) INTO Enfermos
    FROM Historial_Paciente
    WHERE Enfermedad = 1;

    SELECT COUNT(1) INTO Accidentados
    FROM Historial_Paciente
    WHERE Accidente = 1;

    RETURN;
END;
$$ LANGUAGE plpgsql;

-- reporte3
CREATE OR REPLACE FUNCTION reporte3()
RETURNS TABLE (
    nombreDoctor VARCHAR(255),
    repetidos INT
) AS $$
BEGIN
    RETURN QUERY (
        SELECT D.Nombre, COUNT(D.Nombre)
        FROM Historial_Paciente AS hp
        INNER JOIN Doctor AS D ON D.ID_Doctor = hp.FK_ID_Doctor
        INNER JOIN Paciente AS P ON P.ID = hp.FK_ID_Paciente
        GROUP BY D.Nombre
        ORDER BY repetidos DESC
    );
END;
$$ LANGUAGE plpgsql;

-- reporte4
CREATE OR REPLACE FUNCTION reporte4()
RETURNS TABLE (
    Nombre VARCHAR(255)
) AS $$
BEGIN
    RETURN QUERY (
        SELECT M.Nombre
        FROM Receta AS R
        INNER JOIN Paciente AS P ON P.ID = R.FK_ID_Paciente1
        INNER JOIN Doctor AS D ON D.ID_Doctor = R.FK_ID_Doctor1
        INNER JOIN Medicina AS M ON M.ID_Medicina = R.FK_ID_Medicina
    );
END;
$$ LANGUAGE plpgsql;

-- reporte5
CREATE OR REPLACE FUNCTION reporte5()
RETURNS TABLE (
    Nombre VARCHAR(255),
    Edad INT
) AS $$
BEGIN
    RETURN QUERY (
        SELECT Nombre, Edad
        FROM Paciente
        ORDER BY Edad DESC
    );
END;
$$ LANGUAGE plpgsql;

-- reporte6 (asumiendo que "historialTotal" es una función)
CREATE OR REPLACE FUNCTION reporte6()
RETURNS VOID AS $$
BEGIN
    PERFORM historialTotal();
END;
$$ LANGUAGE plpgsql;
