use proyecto;
create table Especialidad(
	ID_Especialida	int identity(1,1) primary key(ID_Especialida),
	Nombre			varchar(50)		NOT NULL,
	Descripcion		varchar(100)	NOT NULL,
	Disponible		bit				NOT NULL
);

create table Doctor(
	ID_Doctor		int identity(1,1) primary key(ID_Doctor),
	Nombre			varchar(70)		NOT NULL,
	Apellido		varchar(70)		NOT NULL,
	Colegiado		int				NOT NULL,
	Disponible		bit				NOT NULL,
	FK_ID_Especialidad int			NOT NULL
	CONSTRAINT FK_ID_Especialidad foreign key (FK_ID_Especialidad)
	REFERENCES Especialidad (ID_Especialida)   ON DELETE CASCADE
  ON UPDATE CASCADE
);        
Create table Medicina(
ID_Medicina			int identity(1,1) primary key(ID_Medicina),
Nombre				varchar(100)	NOT NULL,
Perecedero			bit				NOT NULL,
Fecha_Ingreso		smalldatetime	NOT NULL,
Fecha_Lote			smalldatetime	NOT NULL,
Fecha_Caducidad		smalldatetime			,
Casa				varchar(100)	NOT NULL,
TipoMedicamento		varchar(50)		NOT NULL,
Descripcion			varchar(255) 			,
Imagen 			ntext
);

-- Tabla para las clínicas
create table Clinica (
    ID          int IDENTITY(1,1) not null primary key,
    Nombre      varchar(100) NOT NULL,
    Direccion   varchar(100) NOT NULL
);

-- Tabla para las habitaciones
create table Habitacion (
    ID          int IDENTITY(100,1) not null primary key,
    Numero      int not null,
    Tipo        varchar(50) NOT NULL,
    ClinicaID   int,  -- Referencia a la clínica a la que pertenece la habitación
    foreign key (ClinicaID) references Clinica(ID)
);


-- Tabla para los pacientes
create table Paciente(
    ID              int IDENTITY(1,1) not null primary key,
    Identificador   char(30) NOT NULL,
    Nombre          varchar(70) NOT NULL,
    Apellido        varchar(70) NOT NULL,
    Residencia      varchar(70) NOT NULL,
    Contacto        int NOT NULL,
    Estado          varchar(100) NOT NULL,
    AltaBaja        bit NOT NULL,
    Edad            int not null,
    Visitas         int not null,
    ClinicaID       int, -- Referencia a la clínica a la que pertenece el paciente
    HabitacionID    int,  -- Referencia a la habitación de la clínica asignada al paciente
    foreign key (ClinicaID) references Clinica(ID),
    foreign key (HabitacionID) references Habitacion(ID)
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
Contrasena			char(30) NOT NULL,
ActivoInactivo		bit NOT NULL,
---FK1
FK_ID_TipoUsuario	int NOT NULL
CONSTRAINT FK_ID_TipoUsuario FOREIGN KEY(FK_ID_TipoUsuario)
REFERENCES Tipo_Usuario (ID_TipoUsuario)   ON DELETE CASCADE
  ON UPDATE CASCADE
);

create table Historial_Paciente(
---FK1
FK_ID_Paciente		int NOT NULL
CONSTRAINT FK_ID_Paciente foreign key (FK_ID_Paciente)
REFERENCES	Paciente(ID)   ON DELETE CASCADE
  ON UPDATE CASCADE,
---FK2
FK_ID_Doctor					int	not null
CONSTRAINT FK_ID_Doctor foreign key (FK_ID_Doctor)
REFERENCES Doctor (ID_Doctor)   ON DELETE CASCADE
  ON UPDATE CASCADE,
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
REFERENCES Doctor (ID_Doctor)   ON DELETE CASCADE
  ON UPDATE CASCADE,
---end FK
---FK2
FK_ID_Medicina		int NOT NULL 
CONSTRAINT FK_ID_Medicina foreign key(FK_ID_Medicina)
REFERENCES Medicina(ID_Medicina)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
---end FK
---FK3
FK_ID_Paciente1		int NOT NULL	
CONSTRAINT FK_ID_Paciente1 foreign key (FK_ID_Paciente1)
REFERENCES Paciente(ID)   ON DELETE CASCADE
  ON UPDATE CASCADE,
---end FK
FechaReceta			smalldatetime not null
);