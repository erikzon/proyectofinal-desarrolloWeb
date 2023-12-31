use proyecto;
---STORE PROCELUDE
--CRUD


----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
---Create

go
create proc createEspecialidad
	@Nombre			varchar(50),
	@Descripcion	varchar(100),
	@Disponible		bit	
as
begin try
	insert into Especialidad values(@Nombre,@Descripcion,@Disponible)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createDoctor

	@Nombre			varchar(70),
	@Apellido		varchar(70),
	@Colegiado		int,
	@Disponible		bit,
	@FK_ID_Especialidad int	
as
begin try
	insert into Doctor values(@Nombre,@Apellido,@Colegiado,@Disponible,@FK_ID_Especialidad)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
CREATE PROC createMedicina
@Nombre				varchar(100),
@Perecedero			bit,
@Fecha_Ingreso		smalldatetime,
@Fecha_Lote			smalldatetime,
@Fecha_Caducidad	smalldatetime,
@Casa				varchar(100),
@TipoMedicamento	varchar(50),
@Descripcion		varchar(255),
@Imagen				ntext
AS
BEGIN TRY
    IF @Perecedero = 1 
        INSERT INTO Medicina VALUES (@Nombre,@Perecedero,@Fecha_Ingreso,@Fecha_Lote,@Fecha_Caducidad,@Casa,@TipoMedicamento,@Descripcion,@Imagen)
    IF @Perecedero = 0
        INSERT INTO Medicina VALUES (@Nombre,@Perecedero,@Fecha_Ingreso,@Fecha_Lote, NULL,@Casa,@TipoMedicamento,@Descripcion,@Imagen)
END TRY

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go


-- Insertar clínicas en la tabla Clinica
insert into Clinica (Nombre, Direccion)
values
('Clínica Central', 'Avenida X'),
( 'Clínica del Norte', 'Calle Y'),
( 'Clínica del Este', 'Calle Z'),
( 'Clínica del Sur', 'Avenida W'),
( 'Clínica Occidental', 'Calle V');

-- Insertar habitaciones en la tabla Habitacion
insert into Habitacion (Numero, Tipo, ClinicaID)
values
( 101, 'Habitación individual', 1),
( 102, 'Habitación compartida', 1),
( 201, 'Habitación individual', 2),
( 202, 'Habitación compartida', 2),
( 301, 'Habitación individual', 3),
( 401, 'Habitación individual', 1),
( 402, 'Habitación compartida', 1),
( 501, 'Habitación individual', 2),
( 502, 'Habitación compartida', 2),
( 601, 'Habitación individual', 3);


-- Insertar pacientes en la tabla Paciente
insert into Paciente (Identificador, Nombre, Apellido, Residencia, Contacto, Estado, AltaBaja, Edad, Visitas, ClinicaID, HabitacionID)
values
( 'PAC001', 'Juan', 'Pérez', 'Calle A', 123456789, 'En espera', 1, 35, 2, 1, 100),
( 'PAC002', 'María', 'Gómez', 'Calle B', 987654321, 'En tratamiento', 0, 28, 4, 1, 101),
( 'PAC003', 'Carlos', 'López', 'Calle C', 555555555, 'En tratamiento', 0, 42, 1, 2, 102),
( 'PAC004', 'Luisa', 'Martínez', 'Calle D', 333333333, 'En espera', 1, 22, 3, 2, 103),
( 'PAC005', 'Ana', 'Ramírez', 'Calle E', 777777777, 'En tratamiento', 0, 50, 2, 1, 104);





go
create proc createTipo_Usuario
@Nombre				char(50),
@ModuloPaciente		bit ,
@ModuloDoctor		bit ,
@ModuloMedicina		bit ,
@ModuloReporte		bit 
as
begin try
	insert into Tipo_Usuario values (@Nombre,@ModuloPaciente,@ModuloDoctor, @ModuloMedicina, @ModuloReporte)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createUsuario
@Usuario				varchar(75),
@Contrasena			    char(30),
@ActivoInactivo			bit ,
@TipoUsuario			int 

as
begin try
	insert into Usuario values (@Usuario, @Contrasena, @ActivoInactivo,@TipoUsuario)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createHistorial_Paciente

@FK_ID_Paciente		int,
@FK_ID_Doctor		int ,
@FechaIngreso		smalldatetime ,
@FechaSalida		smalldatetime ,
@Accidente			bit ,
@Enfermedad			bit
as
begin try
	Declare @visitas as int
	set @visitas = (select Visitas from Paciente where ID = @FK_ID_Paciente)
	set @visitas = (@visitas+1)
	insert into Historial_Paciente values (@FK_ID_Paciente, @FK_ID_Doctor, @FechaIngreso, @FechaSalida, @Accidente,@Enfermedad)
	update Paciente set Visitas=@visitas where ID = @FK_ID_Paciente 
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
GO

go
create proc createReceta
@FK_ID_Doctor		int,
@FK_ID_Medicina		int,
@FK_ID_Persona		int,
@FechaReceta		smalldatetime

as
begin try
insert into Receta values (@FK_ID_Doctor,@FK_ID_Medicina,@FK_ID_Persona,@FechaReceta)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

----/////////////////////////////////////////---
---Read
go
create proc readEspecialidad
as 
begin try
select * from Especialidad
end try
begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch


go
create proc readDoctor
as 
begin try
	select D.Nombre,D.Apellido,D.Colegiado, D.Disponible,e.Nombre,E.Descripcion
	from Doctor as D
	inner join Especialidad as E  on E.ID_Especialida = D.FK_ID_Especialidad
end try 
begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch

go


go
create proc readMedicina
as
begin try
select ID_Medicina as 'ID',Nombre,Perecedero,CONVERT(VARCHAR(20), Fecha_Ingreso, 103) as 'Ingreso', CONVERT(VARCHAR(20), Fecha_Lote, 103)  as 'Lote', CONVERT(VARCHAR(20), Fecha_Caducidad, 103) as 'Caducidad', Casa, TipoMedicamento as 'Tipo', Imagen, Descripcion   from Medicina

end try 
begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc readTipo_usuario
as 
begin try
select * from Tipo_Usuario
end try 
begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch
go

go 
create proc readUsuario
as
begin try
SELECT U.Usuario, U.Contrasena, U.ActivoInactivo, TU.Nombre as 'TipoUsuario'
FROM Usuario U
JOIN Tipo_Usuario TU ON U.FK_ID_TipoUsuario = TU.ID_TipoUsuario;

end try 
begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch
go

go 
create proc readPaciente
as
begin try
SELECT P.ID as 'Identificador', P.Nombre, P.Apellido, P.Residencia, P.Contacto, P.Estado, P.AltaBaja, P.Edad, P.Visitas, P.ClinicaID, H.Numero as 'Habitacion'
FROM Paciente P
JOIN Habitacion H ON P.HabitacionID = H.ID;
end try 
begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch
GO

go
create proc readReceta
@ID int
as
begin try
	if @ID > 0
	select 
	R.ID_Receta,r.FechaReceta,
	p.identificador,p.nombre,p.apellido,
	d.Colegiado,d.Nombre,d.Apellido,
	m.ID_Medicina,m.Nombre,m.Casa,m.TipoMedicamento
	from Receta as R
	inner join Paciente as P on p.ID = r.FK_ID_Paciente1
	inner join Doctor as D on D.ID_Doctor = r.FK_ID_Doctor1
	inner join Medicina as M on M.ID_Medicina = r.FK_ID_Medicina
	where ID_Receta =  @ID
end try

begin catch
select
ERROR_PROCEDURE()as ErrorProcedure,
ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc recetaTotal
as
	select 
	R.ID_Receta,r.FechaReceta,
	p.identificador,p.nombre,p.apellido,
	d.Colegiado,d.Nombre,d.Apellido,
	m.ID_Medicina,m.Nombre,m.Casa,m.TipoMedicamento
	from Receta as R
	inner join Paciente as P on p.ID = r.FK_ID_Paciente1
	inner join Doctor as D on D.ID_Doctor = r.FK_ID_Doctor1
	inner join Medicina as M on M.ID_Medicina = r.FK_ID_Medicina
go


----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
---Update
go
create proc updateEspecialidad
@ID_Especialidad int,
@Nombre			varchar(50),
@Descripcion	varchar(100)
as
begin try
update Especialidad set Nombre=@Nombre, Descripcion=@Descripcion where ID_Especialida=@ID_Especialidad
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updateDoctor
@ID_Doctor		int,
@Nombre			varchar(70),
@Apellido		varchar(70),
@Colegiado		int,
@FK_ID_Especialidad int	
as
begin try
update  Doctor set Nombre=@Nombre,Apellido=@Apellido where ID_Doctor=@ID_Doctor
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go


go
create proc updateMedicina
@ID_Medicina		int,
@Nombre				varchar(100),
@Perecedero			bit			,
@Fecha_Ingreso		smalldatetime,
@Fecha_Lote			smalldatetime,
@Fecha_Caducidad	smalldatetime,
@Casa				varchar(100),
@TipoMedicamento	varchar(50)

as
begin try
if @Perecedero = 1 
	update Medicina set 
		Nombre=@Nombre,
		Perecedero=@Perecedero,
		Fecha_Ingreso=@Fecha_Ingreso,
		Fecha_lote=@Fecha_Lote,
		Fecha_Caducidad=@Fecha_Caducidad,
		Casa=@Casa,
		TipoMedicamento=@TipoMedicamento 

	where ID_Medicina=@ID_Medicina

if @Perecedero = 0
	update Medicina set 
		Nombre=@Nombre,
		Perecedero=@Perecedero,
		Fecha_Ingreso=@Fecha_Ingreso,
		Fecha_lote=@Fecha_Lote,
		Fecha_Caducidad=NULL,
		Casa=@Casa,
		TipoMedicamento=@TipoMedicamento  
	where ID_Medicina=@ID_Medicina
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updatePaciente
@Identificador		char(30),
@Nombre				varchar(70) ,
@Apellido			varchar(70) ,
@Residencia			varchar(70) , 
@Contacto			int			,
@Estado				varchar(100),
@Edad				int,
@Visitas			int
as
begin try
update Paciente set 
		Nombre=@Nombre,
		Apellido=@Apellido, 
		Residencia=@Residencia,
		Contacto=@Contacto, 
		Estado=@Estado,
		Edad=@Edad,
		visitas=@Visitas
where	Identificador=@Identificador

end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updateTipo_Usuario
@ID_TipoUsuario		int,
@Nombre				char(50),
@ModuloPaciente		bit ,
@ModuloDoctor		bit ,
@ModuloMedicina		bit ,
@ModuloReporte		bit 
as
begin try
	update Tipo_Usuario set 
	Nombre=@Nombre,
	ModuloPaciente=@ModuloPaciente,
	ModuloDoctor=@ModuloDoctor, 
	ModuloMedicina=@ModuloMedicina, 
	ModuloReporte=@ModuloReporte
	where ID_TipoUsuario=@ID_TipoUsuario
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updateUsuario
@Usuario				varchar(75),
@Contrasena			char(30),
@ActivoInactivo			bit ,
@FK_ID_TipoUsuario			int 

as
begin try
	update Usuario set 
	Contrasena = @Contrasena, 
	FK_ID_TipoUsuario = @FK_ID_TipoUsuario
	where Usuario=@Usuario 
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go


----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
----/////////////////////////////////////////---
---Delete
go
create proc deleteEspecialidad
@ID_Especialidad int,
@Disponible bit
as
begin try
update Especialidad set Disponible=@Disponible where ID_Especialida=@ID_Especialidad
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc deleteDoctor
@ID_Doctor  varchar(45),
@Disponible bit
as
begin try
	update Doctor set Disponible=@Disponible where Apellido=@ID_Doctor
end try


begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

-- exec readDoctor

go
create proc deletePaciente
@Identificador	char(30),
@AltaBaja	bit
as
begin try
	update Paciente set AltaBaja=@AltaBaja where Nombre=@Identificador
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc deleteUsuario
@ID_Usuario			varchar(45),
@ActivoInactivo		bit
as
begin try
	update Usuario set ActivoInactivo = @ActivoInactivo where Usuario = @ID_Usuario
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go



---Obtener historial de un cliente
go
create proc historial
@ID		INT
as
select p.Nombre, p.Apellido, p.Estado,p.Contacto,p.Edad,p.AltaBaja, D.Nombre, D.Apellido,d.Colegiado, FechaIngreso, FechaSalida,Enfermedad,Accidente from Historial_Paciente as hp
inner join Doctor as D on D.ID_Doctor = hp.FK_ID_Doctor
inner join Paciente as P on P.ID = hp.FK_ID_Paciente
where hp.FK_ID_Paciente = @ID
GO

---Historial general
go
create proc historialTotal
as
select p.Nombre, p.Apellido, p.Estado,p.Contacto,p.Edad,p.AltaBaja, D.Nombre, D.Apellido,d.Colegiado, FechaIngreso, FechaSalida,Enfermedad,Accidente
from Historial_Paciente as hp
inner join Doctor as D on D.ID_Doctor = hp.FK_ID_Doctor
inner join Paciente as P on P.ID = hp.FK_ID_Paciente
GO


---login
go 
create proc corroborarUC
@Usuario char(30),
@Contrasena char(30) 
as
begin try
	if (select 1 from Usuario where Usuario=@Usuario and Contrasena=@Contrasena)=1
	select
	1,TU.Nombre,TU.moduloPaciente,TU.ModuloDoctor,TU.ModuloMedicina,TU.ModuloReporte
	from Usuario as Us
	inner join Tipo_Usuario as TU on TU.ID_TipoUsuario = Us.FK_ID_TipoUsuario
	where Usuario=@Usuario and Contrasena=@Contrasena
	else 
	select 0
end try
begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

-- exec readPaciente

-- exec readEspecialidad

exec createEspecialidad 'Otorinoralingolo','revisa nariz y esas cosas',1
exec createEspecialidad 'Anastesiologia','Anestesia a la vieja escuela',1
exec createEspecialidad 'Cardiología','atender la patología y procedimientos cardiológicos en pacientes adultos y pediátricos',1
exec createEspecialidad 'Dermatología','aplicará la terapéutica específica, para la piel',1
exec createEspecialidad 'Hematología','valorará en forma integral a los pacientes adultos con problemas hematológicos',1
exec createEspecialidad 'Nefrología','diagnóstico y tratamiento de las enfermedades renales, equilibrio hidro-electrolítico y ácido básico',1



-- exec readDoctor

exec createDoctor 'DR. Mau','Ricio',1231,1,1
exec createDoctor 'DR. Dog','Chau',1232,1,2
exec createDoctor 'DR. Mario','Marito',1233,1,3
exec createDoctor 'DR. Cat','Odo',1234,1,4
exec createDoctor 'DR. An','Odo',1235,1,5
exec createDoctor 'DR. Rey','Ciceron',1236,1,6

-- select ID_Especialida as value, Nombre as label from Especialidad


-- exec readMedicina

exec createMedicina 'GastroInter3000',1,'2022-10-11','2022-09-16','2022-01-01','Bayer','Digestivo','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';
exec createMedicina 'Complejo B',0,'2022-10-12','2022-09-15','2022-02-01','ByB','Nervioso','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';
exec createMedicina 'Cardio Aspirina',1,'2022-10-13','2022-09-14','2022-03-01','Faenco','Cardiologico','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';
exec createMedicina 'Vitamina C',0,'2022-10-14','2022-09-13','2022-04-01','Logitech','Vitaminas','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';
exec createMedicina 'Parecetamol (La vieja confiable)',1,'2022-10-15','2022-09-12','2022-05-01','MSI','Analgesicos','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';
exec createMedicina 'Te Natural',0,'2022-10-16','2022-09-11','2022-06-01','SyS','Natural','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';
exec createMedicina 'otra prueba',1,'2022-10-16','2022-09-11','2022-06-01','miau','cardiologo','descripcion generica', 'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEEklEQVRoge1ZS0iVURAeKy1KqDSiNi3saYtIsSStRYvUIKgwITHaBJYUtK5FEJm6bJG3Nq1KLSMwitRetmnTIi0oCXotelnZw572oObzPxf+5s797/kf3R448IFcZ76Zc8+cmTnnEo3K/yHZjNWMRsYZxh3GK8YXA/zdb/4HnQrGpD8SqUsyyAm6nfGJ8cMnYHOcnMVkpDl2qmLcDBB0MtxgVKYj8LmMixEGLnGeMed3BV/DeOfh/C6jmVHNKGDkMDINcsxn+F+Mcc+DZ8joRSbIz4Ykzr4xWhjLAnCWMFoNh8ZdTxGcDRAcSuKgizEvrAOW+eSkjuYjRiEX0aiQfmBsCUOaRGoZHxV/+4IS1ihkzxiFYSP1kCLGc8XvRr9EqDbywA6Qs92/W+BDLuItY7YfElkqkTa23/xKxlHGQ3K68HtGL6OJMcuSAzsh06nb0nakSckttMn56Yyziq0bWNBuxhgLvlrFfn0qI5x42WHPWzibSc78Y9uwjpBddekUdn2p7FYLA9ToVKUS32aPj+Dj2GGxgHxK7BMVXgbtQvmYhZMNSnBXGCvI6cJTGZsZT4XOG8ZkC/42YdeWTBEjsZwqbTpsl7DBto9T9PIYg0K3zoK/VNjgcE/UFGX6YLaxydNzLhts91wP3V3Cx0kLfsRwX9iVaYpNQqnZghyyiHGLnJTYmUK3WPi4ZunjsLBr0JTOCKVIJ0Ijq4SPHks7ORWc1pRkGVwcMlgpExhXhY8DlraFwq5fU3oplHLCxfuLzGBcFvzAckv7acLuhaY0LJQyQ4XsCMrkHtIvQqd88IwXtp81JbmArKBRG9lOzhykNTF01Ck+uKwWIGt0bsDAydh+JT34C+SkhB+xSiF5iAsCBB4XbQG4S2xjjA3AZ3WIoy6jSKHX5DRETKDZIbg2idjUMiqvj7EQDqMW2cj2a0oVQglPH2l/MVMEMTwgi1FCG+ZK0hOjp6BXuGPC7VAd5iAnhHJLGgJMJXg/dcfU6qUs0wjTZdCL/BrGY8YTxrqAHAsp8UJT7mWAfLsuDGyulJo8cnEMBOS4JGLpJYtzWSmMgNoAzsMuoE6Jw3on5VMfbkFFPgMIk0JLKbGgdPohwBP3kCDAY1M6HrYWUOLDFi5LeX6JqilxC0G8JKpIFSkm/WmxKihhvUKGrd0aNlJF6kj/qWpvGFKc+JhCGp8q88OQG0GplNUmjoMR8I8sQtuJeJ9AYyklf2MHdNFh0aS+J+EO9c1rgiduebDdwNMHhi5cwDH+YqTOMsg1n9UYHTnbuIGX6MA5n0rwxN3t4TwsUCp9V5sgglfivggDR4ddm47A3YI8xuyEt0rtp6FUgA3OTzn9BWM7xlvM6LhodDBuk3PHHjYYNJ91GJ0y8hiJR+Vfkp/+tnMpuMKIrgAAAABJRU5ErkJggg==';

exec createReceta 1,1,1,'2022-10-23'
exec createReceta 2,2,2,'2022-10-22'
exec createReceta 3,3,3,'2022-10-21'
exec createReceta 4,4,4,'2022-10-24'
exec createReceta 5,5,5,'2022-10-25'
exec createReceta 6,6,5,'2022-10-26'

-- EXEC readReceta 1
-- exec recetaTotal

exec createHistorial_Paciente 1,1,'2022-10-23','2022-10-23',1,0
exec createHistorial_Paciente 2,2,'2022-10-23','2022-10-23',0,1
exec createHistorial_Paciente 3,3,'2022-10-23','2022-10-23',1,0
exec createHistorial_Paciente 4,4,'2022-10-23','2022-10-23',0,1
exec createHistorial_Paciente 5,5,'2022-10-23','2022-10-23',1,0


exec createTipo_Usuario 'Administrado',1,1,1,1
exec createTipo_Usuario 'Operador',1,1,1,0
exec createTipo_Usuario 'Consulta',1,0,0,0
exec createTipo_Usuario 'reportes',0,0,0,1

exec createUsuario 'hugo','abcdef',1,1
exec createUsuario 'vito','4125',1,2
exec createUsuario 'erick','4125',1,1
exec createUsuario 'edgar','4125',1,3


-- exec corroborarUC 'hugo','abcdef'

-- exec readUsuario
-- exec readTipo_usuario

-- exec historial 1


-- exec readReceta 1
-- exec recetaTotal

-- exec readPaciente

go
create proc reporte1
as
select top 3 * from Paciente order by visitas desc
GO

go
create proc reporte2
as
select count (1) as Enfermos
from Historial_Paciente as hp
where Enfermedad = 1 
select count (1) as Accidentados
from Historial_Paciente as hp
where Accidente = 1
GO

GO
create proc reporte3
as
select D.Nombre as nombreDoctor, count(D.Nombre) as repetidos
from Historial_Paciente as hp
inner join Doctor as D on D.ID_Doctor = hp.FK_ID_Doctor
inner join Paciente as P on P.ID = hp.FK_ID_Paciente group by D.Nombre order by repetidos desc
GO

GO
create proc reporte4
as
select m.Nombre
	from Receta as R
	inner join Paciente as P on p.ID = r.FK_ID_Paciente1
	inner join Doctor as D on D.ID_Doctor = r.FK_ID_Doctor1
	inner join Medicina as M on M.ID_Medicina = r.FK_ID_Medicina
GO

GO
create proc reporte5
as
select ID,Nombre, Edad from Paciente order by edad desc
GO

GO
create proc reporte6
as
exec historialTotal
GO

-- exec reporte6

-- exec readMedicina
-- select * from Medicina where ID_Medicina = 2

