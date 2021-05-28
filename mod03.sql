-- Gestion des verrous dans une requete SELECT

select * from dbo.CLIENTS
with (updlock)
-------------------------------------------------------
-- démarrage d'une transaction et insertion de ligne
-- avec point d'arrêt de la transaction

Begin tran ;
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) 
values(26,'Zazou','Zoé','rue des Zinnia','59123','Zuydcoote','05 59 17 18 19','CD');
save tran P1;
-- insertion d'un 2eme client qui ne sera pas validé contrairement au 1er

insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) 
values(25,'Yvres','Yann','rue des yuccas','43200','Yssingeaux','04 43 16 17 18','CD');
rollback tran;


-------------------------------------------------------------------------------------------
-- création de la base GESCOM

 CREATE DATABASE GESCOM
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'GESCOM', 
FILENAME = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\DATA\GESCOM.mdf' , 
SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'GESCOM_log', 
FILENAME = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\DATA\GESCOM_log.ldf' , 
SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
 go

 --Modification de la taille d'un fichier de GESCOM

USE [master]
GO
ALTER DATABASE [GESCOM] 
MODIFY FILE ( NAME = N'GESCOM', SIZE = 51200KB )
GO

-- Ajout d'un fichier à la base GESCOM

USE [master]
GO
ALTER DATABASE [GESCOM] 
ADD FILE ( NAME = N'gescom2', 
FILENAME = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\DATA\gescom2.ndf' , 
SIZE = 8192KB , FILEGROWTH = 65536KB ) 
TO FILEGROUP [PRIMARY]
GO

-------------------------------------------------------------------------------------------------
-- Modification de l'emplacement de la base Tempdb

USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, FILENAME = 'D:\donnees\tempdb.mdf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, FILENAME = 'D:\donnees\templog.ldf');
GO

-------------------------------------------------------------------------------------------------
-- Réduction de la taille de la base GESCOM
USE [GESCOM]
GO
DBCC SHRINKDATABASE(N'GESCOM', 10 )
GO


-- Passage de la base GESCOM en mode utilisateur restreint

USE [master]
GO
ALTER DATABASE [GESCOM] SET  RESTRICTED_USER WITH NO_WAIT
GO

-- Ajout d'un groupe de fichiers à la base GESCOM
USE [master]
GO
ALTER DATABASE [GESCOM] ADD FILEGROUP [g2]
GO

-- Ajout d'un fichier à ce groupe de fichiers
ALTER DATABASE [GESCOM] 
ADD FILE ( NAME = N'f2', 
FILENAME = N'd:\donnees\f2.ndf' ,
SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [g2]
GO

-- Ajout d'une table dans ce groupe de fichiers à la base GESCOM
CREATE TABLE [dbo].[CATEGORIES](
	[code_cat] [int] IDENTITY(100,1) NOT NULL,
	[libelle_cat] [nvarchar](200) NULL
) ON [g2]
GO

-----------------------------------------------------------------------------
-- chargement de donnée avec création de la table dbo.cli
select nom,prenom
into cli
from dbo.CLIENTS;

-- Chargement de données dans une table existante: dbo.clients

insert into cli(nom,prenom)
select nom,prenom
from dbo.clients;

--------------------------------------------------------------------------------
-- Création d'un index non ordonné sur la table des clients

create index idxclientsville on dbo.clients(ville);

-- en ajoutant l'option INCLUDE
create index idxclientsprenomnom 
on dbo.clients(prenom)
include (nom);

-- reconstruction de tous les index de la table des clients avec un facteur de remplissage de 40%
alter index all on dbo.clients rebuild with (fillfactor=40);

-- index sur des colonnes calculées
alter table dbo.articles
add ttc as (prixht_art*1.2) persisted;
go
create index idxarticlesttc
on dbo.articles(ttc);

-- index sur des vues
create view dbo.clientsdeParis
with schemabinding as
select numero,nom,prenom,adresse,codepostal,ville
from dbo.CLIENTS
where ville='Paris' ;
go
create unique clustered index  idxclientsdeparisadresse
on dbo.clientsdeparis(nom,prenom,adresse) ;

-- index filtré

create index  idxclientsparis
on dbo.clients(nom,prenom)
where ville='Paris';

-- index columnstore
CREATE  COLUMNSTORE INDEX idx_col_clients ON dbo.clients(codepostal,ville)

-- Index XML: creation de la table
create table dbo.catalogue
(numero int constraint PK_catalogue Primary Key,
page XML);

-- creation de l'index principal et des 3 index secondaires
create primary xml index pidx_page on dbo.catalogue(page);
go
create xml index idx_page_path on dbo.catalogue(page)
	using xml index pidx_page for path;
go
create xml index idx_page_property on dbo.catalogue(page)
	using xml index pidx_page for property;
go
create xml index idx_page_value on dbo.catalogue(page)
	using xml index pidx_page for value;
go

-- création d'index spatial (ajout d'une colonne geography à indexer ensuite)
alter table dbo.stocks
add position geography;
go
create spatial index idxstockposition
on dbo.stocks(position)
using geography_grid;

-------------------------------------------------------------------------
--Partitionnement de table
-- création de la fonction de partition

create partition function pfclients(int)
as range left for values(10000,20000,30000);

-- création du schéma de partition
create partition scheme schemaclients
as partition pfclients
to (g1,g2,g3,g4);

-- création d'une table partitionnée avec ce schéma de partition
create table dbo.Tclients
(numero int identity(1,1) constraint pk_tclients primary key,
nom nvarchar(80),
prenom nvarchar(80),
adresse nvarchar(100),
codepostal char(5),
cille nvarchar(80),
telephone char(14))
on schemaclients(numero);

-- création d'un index partitionné sur cette table
create index idx_tclients_nom
on dbo.tclients(nom)
on schemaclients(numero);

-----------------------------------------------------------------------
-- chiffrement d'une base de données
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
go
CREATE CERTIFICATE Cert_gescom WITH SUBJECT = 'Certificat pour Gescom';
go
USE GESCOM;
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE Cert_gescom;
GO
ALTER DATABASE GESCOM
SET ENCRYPTION ON;
GO


---------------------------------------------------------------------
-- création et utilisation d'une table temporelle

CREATE TABLE dbo.produits( 
reference char(8) constraint pk_produits primary key,
designation varchar(200), 
debutValidite datetime2 GENERATED ALWAYS AS ROW START NOT NULL, 
finValidite datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
PERIOD FOR SYSTEM_TIME (debutValidite, finValidite) 
) WITH (SYSTEM_VERSIONING=ON (HISTORY_TABLE= dbo.produitsHistorique)) ;
go

select * from dbo.produits
FOR SYSTEM_TIME AS OF '2018-04-15'

-- Corrigé des exercices
-- création base LivreTSQL
CREATE DATABASE LivreTSQL  
    ON PRIMARY (  
           NAME=LivreTSQL,  
           FILENAME='c:\donnees\LivreTSQL.mdf',  
           SIZE=10Mb  
    )  
    LOG ON (  
           NAME=LivreTSQL_log,  
           FILENAME='c:\donnees\LivreTSQL_log.ldf',  
           SIZE=8Mb  
);


-- ajout de fichier et groupe de fichiers
ALTER DATABASE LivreTSQL  
     ADD FILEGROUP Data;

ALTER DATABASE LivreTSQL  
     ADD FILE (  
           NAME=data1,  
           FILENAME='c:\donnees\data1.ndf',  
           SIZE=50Mb,  
           MAXSIZE=50Mb  
     )  
     TO FILEGROUP Data;

ALTER DATABASE LivreTSQL  
     ADD FILE (  
           NAME=data2,  
           FILENAME='c:\donnees\data2.ndf',  
           SIZE=10Mb,  
           MAXSIZE=50Mb,  
           FILEGROWTH=10Mb  
     )  
     TO FILEGROUP Data;
