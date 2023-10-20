use master

-- Eliminar la base de datos 'proyecto' si existe
if exists (select * from sys.databases where name = 'proyecto')
begin
    alter database proyecto set single_user with rollback immediate;
    drop database proyecto;
end

-- Crear la base de datos 'proyecto'
create database proyecto;

-- Usar la base de datos 'proyecto'
use proyecto;