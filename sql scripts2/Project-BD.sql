use master
drop database BD_Project
create database BD_Project
use BD_Project

 
--- Creacion de las tablas
create table Especialidad(
	ID_Especialida	int identity(1,1) primary key(ID_Especialida),
	Nombre			varchar(50)		NOT NULL,
	Descripcion		varchar(100)	NOT NULL,
	Disponible		bit				NOT NULL
);

create table Doctor(
	ID_Doctor		int identity(1,1) primary key(ID_Doctor),
	DPI				int				NOT NULL,
	Nombre			varchar(70)		NOT NULL,
	Apellido		varchar(70)		NOT NULL,
	Colegiado		int				NOT NULL,
	Disponible		bit				NOT NULL,
	FK_ID_Especialidad int			NOT NULL
	CONSTRAINT FK_ID_Especialidad foreign key (FK_ID_Especialidad)
	REFERENCES Especialidad (ID_Especialida)
);

Create table Casa(
ID_Casa				int identity(1,1) primary key(ID_Casa),
Nombre				varchar(50)		NOT NULL,
Puntuacion			decimal			NOT NULL
);

Create table Tipo_Producto(
ID_TipoProducto		int identity(1,1) primary key(ID_TipoProducto),
Descripcion			varchar(100)	NOT NULL
);

Create table Medicina(
ID_Medicina			int identity(1,1) primary key(ID_Medicina),
Nombre				varchar(100)	NOT NULL,
Perecedero			bit				NOT NULL,
Fecha_Ingreso		smalldatetime	NOT NULL,
Fecha_Lote			smalldatetime	NOT NULL,
Fecha_Caducidad		smalldatetime			,
---FK1
FK_ID_Casa			int				NOT NULL	
CONSTRAINT FK_ID_Casa foreign key (FK_ID_Casa)
REFERENCES Casa (ID_Casa),
---FK2
FK_ID_TMedicamento	int				NOT NULL
CONSTRAINT FK_ID_TMedicamento foreign key(FK_ID_TMedicamento)
REFERENCES Tipo_Producto(ID_TipoProducto)
);

create table Persona(
DPI					int NOT NULL primary key(DPI),
Nombre				varchar(70) NOT NULL,
Apellido			varchar(70) NOT NULL,
Residencia			varchar(70) NOT NULL, 
Contacto			int NOT NULL,
Estado				varchar(100) NOT NULL,
AltaBaja			bit NOT NULL,
Edad				int not  null
);

create table Tipo_Usuario(
ID_TipoUsuario		int identity(1,1) primary key(ID_TipoUsuario),
Nombre				char(50),
ModuloPaciente		bit NOT NULL,
ModuloDoctor		bit NOT NULL,
ModuloMedicina		bit NOT NULL,
ModuloReporte		bit NOT NULL
);

create table Usuario(
Usuario				varchar(75) NOT NULL primary key(Usuario),
Constraseña			char(30) NOT NULL,
ActivoInactivo		bit NOT NULL,
---FK1
FK_ID_TipoUsuario	int NOT NULL
CONSTRAINT FK_ID_TipoUsuario FOREIGN KEY(FK_ID_TipoUsuario)
REFERENCES Tipo_Usuario (ID_TipoUsuario),
DPI					int NOT NULL
);

create table Paciente(
ID_Paciente			int identity (1,1)primary key(ID_Paciente),
Identificador		char(30) NOT NULL,
---FK1
FK_ID_Persona		int NOT NULL	
CONSTRAINT FK_ID_Persona foreign key (FK_ID_Persona)
REFERENCES Persona (DPI),
CantidadVisitas		int NOT NULL,
Accidente			bit not null,
Enfermedad			bit not null
);

create table Historial_Paciente(
---FK1
FK_ID_Paciente		int NOT NULL
CONSTRAINT FK_ID_Paciente foreign key (FK_ID_Paciente)
REFERENCES	Paciente(ID_Paciente),
---FK2
FK_ID_Doctor		int NOT NULL
CONSTRAINT FK_ID_Doctor foreign key (FK_ID_Doctor)
REFERENCES Doctor (ID_Doctor),
FechaIngreso		smalldatetime NOT NULL,
FechaSalida			smalldatetime NOT NULL,
Accidente			bit not null,
Enfermedad			bit not null
);

create table Receta(
ID_Receta			int identity(1,1) primary key(ID_Receta),
---FK1
FK_ID_Doctor1		int NOT NULL
CONSTRAINT FK_ID_Doctor1 foreign key (FK_ID_Doctor1)
REFERENCES Doctor (ID_Doctor),
---end FK
---FK2
FK_ID_Medicina		int NOT NULL 
CONSTRAINT FK_ID_Medicina foreign key(FK_ID_Medicina)
REFERENCES Medicina(ID_Medicina),
---end FK
---FK3
FK_ID_Persona1		int NOT NULL	
CONSTRAINT FK_ID_Persona1 foreign key (FK_ID_Persona1)
REFERENCES Persona (DPI),
---end FK
FechaReceta			smalldatetime not null
);
 

---STORE PROCELUDE
--CRUD

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
	@DPI			int,
	@Nombre			varchar(70),
	@Apellido		varchar(70),
	@Colegiado		int,
	@Disponible		bit,
	@FK_ID_Especialidad int	
as
begin try
	insert into Doctor values(@DPI,@Nombre,@Apellido,@Colegiado,@Disponible,@FK_ID_Especialidad)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createCasa
@Nombre				varchar(50),
@Puntuacion			decimal

as
begin try
	insert into Casa values (@Nombre,@Puntuacion)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createTipoProducto
@Descripcion varchar(100)
as
begin try 
insert into Tipo_Producto values (@Descripcion)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createMedicina
@Nombre				varchar(100),
@Perecedero			bit			,
@Fecha_Ingreso		smalldatetime,
@Fecha_Lote			smalldatetime,
@Fecha_Caducidad	smalldatetime,
@FK_ID_Casa			int,
@FK_ID_TMedicamento	int

as
begin try
if @Perecedero = 1 
insert into Medicina values (@Nombre,@Perecedero,@Fecha_Ingreso,@Fecha_Lote,@Fecha_Caducidad,@FK_ID_Casa,@FK_ID_TMedicamento)
if @Perecedero = 0
insert into Medicina values (@Nombre,@Perecedero,@Fecha_Ingreso,@Fecha_Lote, NULL,@FK_ID_Casa,@FK_ID_TMedicamento)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc createPersona
@DPI				int ,
@Nombre				varchar(70) ,
@Apellido			varchar(70) ,
@Residencia			varchar(70) , 
@Contacto			int			,
@Estado				varchar(100),
@AltaBaja			bit,
@Edad				int

as
begin try
insert into Persona values (@DPI,@Nombre,@Apellido, @Residencia,@Contacto, @Estado,@AltaBaja,@Edad)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go


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
@Constraseña			char(30),
@ActivoInactivo			bit ,
@TipoUsuario			int ,
@DPI					int  

as
begin try
	insert into Usuario values (@Usuario, @Constraseña, @ActivoInactivo,@TipoUsuario,@DPI)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go


go
create proc createPaciente 
@FK_ID_Persona			int,
@Accidente				bit,
@Enfermedad				bit
as
begin try
declare @Id				int
declare @Identificador	char(30)
declare @anio			int
declare @anioC			char(4)
set @Id = (select top 1 ID_Paciente  from Paciente order by ID_Paciente ASC)
set @anio = (SELECT YEAR(GETDATE()) AS [Año Actual])
set @Identificador = (select convert(char(30),@Id))
set @anioC = (select CONVERT(char(4),@anio))

insert into Paciente values (@Identificador + @anioC ,@FK_ID_Persona,1,@Accidente,@Enfermedad)
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
	insert into Historial_Paciente values (@FK_ID_Paciente, @FK_ID_Doctor, @FechaIngreso, @FechaSalida, @Accidente,@Enfermedad)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

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

---Read
go
create proc readEspecialidad
as 
select * from Especialidad
go

go
create proc readDoctor
as 
select * from Doctor
go

go
create proc readCasa
as
select * from Casa
go 

go 
create proc readTipo_Producto
as
select * from Tipo_Producto
go

go
create proc readMedicina
as
select * from Medicina
go

go
create proc readPersona
as
select * from Persona
go

go
create proc readTipo_usuario
as 
select * from Tipo_Usuario
go

go 
create proc readUsuario
as
select * from Usuario
go

go 
create proc readPaciente
as
select * from Paciente
go

go
create proc readRecetas
as
select * from Receta
go

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
@DPI			int,
@Nombre			varchar(70),
@Apellido		varchar(70),
@Colegiado		int,
@FK_ID_Especialidad int	
as
begin try
update  Doctor set DPI=@DPI,Nombre=@Nombre,Apellido=@Apellido where ID_Doctor=@ID_Doctor
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updateCasa
@ID_Casa				int,
@Nombre				varchar(50),
@Puntuacion			decimal

as
begin try
	update Casa set Nombre=@Nombre, Puntuacion=@Puntuacion where ID_Casa=@ID_Casa
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updateTipoProducto
@ID_TipoProducto int,
@Descripcion varchar(100)
as
begin try 
	update Tipo_Producto set Descripcion=@Descripcion where ID_TipoProducto=@ID_TipoProducto
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
@FK_ID_Casa			int,
@FK_ID_TMedicamento	int

as
begin try
if @Perecedero = 1 
	update Medicina set 
		Nombre=@Nombre,
		Perecedero=@Perecedero,
		Fecha_Ingreso=@Fecha_Ingreso,
		Fecha_lote=@Fecha_Lote,
		Fecha_Caducidad=@Fecha_Caducidad,
		FK_ID_Casa=@FK_ID_Casa,
		FK_ID_TMedicamento=@FK_ID_TMedicamento 
	where ID_Medicina=@ID_Medicina

if @Perecedero = 0
	update Medicina set 
		Nombre=@Nombre,
		Perecedero=@Perecedero,
		Fecha_Ingreso=@Fecha_Ingreso,
		Fecha_lote=@Fecha_Lote,
		Fecha_Caducidad=NULL,
		FK_ID_Casa=@FK_ID_Casa,
		FK_ID_TMedicamento=@FK_ID_TMedicamento 
	where ID_Medicina=@ID_Medicina
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc updatePersona
@DPI				int ,
@Nombre				varchar(70) ,
@Apellido			varchar(70) ,
@Residencia			varchar(70) , 
@Contacto			int			,
@Estado				varchar(100),
@Edad				int
as
begin try
update Persona set 
	Nombre=@Nombre,
	Apellido=@Apellido, 
	Residencia=@Residencia,
	Contacto=@Contacto, 
	Estado=@Estado,
	Edad=@Edad
where DPI=@DPI

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
@Constraseña			char(30),
@ActivoInactivo			bit ,
@FK_ID_TipoUsuario			int ,
@DPI					int  

as
begin try
	update Usuario set 
	Constraseña = @Constraseña, 
	FK_ID_TipoUsuario = @FK_ID_TipoUsuario,
	DPI = @DPI
	where Usuario=@Usuario 
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go


go
create proc updatePaciente 
@ID_Paciente			int,
@Identificador			char(30),
@FK_ID_Persona			int
as
begin try
update Paciente set Identificador=@Identificador, FK_ID_Persona = @FK_ID_Persona where ID_Paciente=@ID_Paciente
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

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
@ID_Doctor  int,
@Disponible bit
as
begin try
	update Doctor set Disponible=@Disponible where ID_Doctor=@ID_Doctor
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go

go
create proc deletePersona
@ID_Persona	int,
@AltaBaja	bit
as
begin try
	update Persona set AltaBaja=@AltaBaja where @ID_Persona=@ID_Persona
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

---Reportes aparte

go
create proc readHistorial_Paciente
@ID_Pac	char(30)

AS
begin try
DECLARE @Historial AS TABLE(
PacienteNombre			varchar(200),
DoctorNombre			varchar(200),
FechaIngreso			smalldatetime,
FechaSalida				smalldatetime,
Accidente				bit,
Enfermedad				bit
);
declare @ID_Doctor		int
declare @ID_Paciente	int
declare @NPaciente		varchar(150)
declare @APaciente		varchar(150)
declare @NDoctor		varchar(150)
declare @ADoctor		varchar(150)

set @ID_paciente = (Select FK_ID_Paciente from Historial_Paciente where FK_ID_Paciente=@ID_Pac	)
set @ID_Doctor = (Select FK_ID_Doctor from Historial_Paciente where FK_ID_Paciente=@ID_Pac)

set @NPaciente = (select Nombre from Persona where DPI=(select FK_ID_Persona from Paciente where ID_Paciente=@ID_paciente))
set @APaciente = (select Apellido from Persona where DPI=(select FK_ID_Persona from Paciente where ID_Paciente=@ID_paciente))
set @NDoctor = (select Nombre from Doctor where ID_Doctor=@ID_Doctor)
set @ADoctor = (select Apellido from Doctor where ID_Doctor=@ID_Doctor)

insert into @Historial values(
@NPaciente +' '+ @APaciente,
@NDoctor +' '+ @ADoctor,
(select FechaIngreso from Historial_Paciente where FK_ID_Paciente=@ID_Pac),
(select FechaSalida from Historial_Paciente where FK_ID_Paciente=@ID_Pac),
(select Accidente from Historial_Paciente where  FK_ID_Paciente=@ID_Pac),
(select Enfermedad	from Historial_Paciente where  FK_ID_Paciente=@ID_Pac)
)
end try

begin catch
	select 
	ERROR_PROCEDURE()as ErrorProcedure,
	ERROR_MESSAGE() as ErrorMesage
end catch
go






