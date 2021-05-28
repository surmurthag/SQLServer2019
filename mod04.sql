-- Création d'un compte de connexion (login) Windows

USE [master]
GO
CREATE LOGIN [TEST\sql] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO

-- et d'un compte de connexion SQL

USE [master]
GO
CREATE LOGIN Pierre 
WITH PASSWORD=N'Pa$$w0rd', DEFAULT_DATABASE=Gescom
GO

-- création d'un credential
USE [master]
GO
CREATE CREDENTIAL [Antoine] WITH IDENTITY = N'Domaine\Antoine', SECRET = N'Pa$$w0rd'
GO


-- désactivation d'un compte de connexion

 alter login Pierre disable

 -- création d'un compte utilisateur de base de données

USE GESCOM
GO
CREATE USER [Jacques] FOR LOGIN [Jacques]
GO

-- Lister les couples Utilisateur de base de données / Connexion
Use GESCOM;
go

SELECT s.name as "Connexion", p.name as "Utilisateur" 
FROM sys.database_principals p 
INNER JOIN sys.server_principals s 
ON s.sid=p.sid;

-- Lister toutes les connexions et login ayant un accès à une base
DECLARE cLesBases cursor for 
select name 
from sys.databases 
where name not in('master','model','tempdb','msdb'); 

DECLARE @nomBase sysname; 
DECLARE @rqt nvarchar(500) 
BEGIN 
   OPEN cLesBases; 
   FETCH cLesBases INTO @nomBase; 
   WHILE (@@FETCH_STATUS=0) BEGIN 
      set @rqt='SELECT '''+@nomBase+''' as Base,' 
      set @rqt=@rqt+'s.name as Connexion, p.name as Utilisateur ' 
      set @rqt=@rqt+'FROM master.sys.server_principals p ' 
      set @rqt=@rqt+'INNER JOIN '+@nomBase+'.sys.database_principals s ' 
      set @rqt=@rqt+'ON s.sid=p.sid' 
      exec sp_executesql @rqt 
      FETCH cLesBases INTO @nomBase; 
   END; 
   CLOSE cLesBases; 
   DEALLOCATE cLesBases 
END;

----------------------------------------------------------------------
-- Création d'un utilisateur sans connexion associée

sp_configure 'contained database authentication',1
reconfigure

USE [master] ;
GO
ALTER DATABASE [GESCOM] SET CONTAINMENT = PARTIAL WITH NO_WAIT;
GO

use GESCOM;
go
-- utilisateur SQL
CREATE USER test with PASSWORD='Pa$$w0rd';
GO
-- utilisateur Windows
CREATE USER [TEST\sql];
GO

--------------------------------------------------------
--Création de schéma, table et vue
use gescom;
go
create schema RI
authorization dbo;
go

use gescom;
go
create schema schemaexemple
authorization dbo
create table articles
(reference nvarchar(8) constraint pk_articles primary key,
designation nvarchar(200),
prixht money,
tva numeric(4,2))
create view catalogue as
select reference, designation,prixht,tva,prixht*(1+tva)/100 as ttc
from articles ;

------------------------------------------------------------------
-- transfert d'objet d'un schéma à un autre

use gescom;
go
alter schema ri
transfer schemaexemple.catalogue;
------------------------------------------------------------------
-- accorder le droit de créer une vue

use GESCOM
GO
GRANT CREATE VIEW TO Jacques
GO

-- retirer ce droit
use GESCOM
GO
REVOKE CREATE VIEW TO Jacques
GO

-- interdire ce droit
use GESCOM
GO
DENY CREATE VIEW TO Jacques
GO

-- accorder des droits d'accès aux objets
use [GESCOM]
GO
grant all on dbo.commandes to Jacques;
grant select on dbo.articles to Jacques;

-- retrait de droits d'accès aux objets
use [GESCOM]
GO
REVOKE SELECT ON dbo.ARTICLES TO [Jacques] 
GO

-- interdiction d'accès aux objets
use [GESCOM]
GO
DENY INSERT ON dbo.ARTICLES TO Jacques
GO

-----------------------------------------------------
-- droit de sauvegarde au niveau de la base de données
use GESCOM;
go
grant backup database to Jacques;

-------------------------------------------------------
-- lister les utilisateurs d'une base de données

select * from sys.database_principals
where type in ('S','U')

-- lister les permissions accorder à un utilisateur

select * 
from sys.database_permissions
where grantee_principal_id=user_id('Jacques') ;

-- contexte d'exécution

use master;
create login marie with password='Pa$$w0rd', default_database=gescom;
create login paul with password='Pa$$w0rd', default_database=gescom;
go
use GESCOM;
go
create user marie for login marie;
create user paul for login paul;
grant create procedure to marie;
exec sp_addrolemember 'db_datareader','marie'
grant select on schema:: dbo to marie;
grant alter on schema:: dbo to marie;
grant execute on schema:: dbo to marie;
go
grant impersonate on user::marie to paul;

-- connecté en tant que Marie
create proc voir as
select * from dbo.clients;

-- connecté en tant que Paul
execute as user 'Marie';
select ORIGINAL_LOGIN(),SUSER_NAME();
exec dbo.voir

--------------------------------------------------------------------------
-- ajouter une connexion à un role
ALTER SERVER ROLE serveradmin ADD MEMBER Jacques;

-- supprimer cette connexion du role
ALTER SERVER ROLE serveradmin DROP MEMBER Jacques;

--------------------------------------------------------------------------
-- Liste des utilisateurs appartenant aux roles de bases de données

select utilisateurs.name, roles.name
from sys.database_role_members as drm
join sys.database_principals as utilisateurs
	on drm.member_principal_id=utilisateurs.principal_id
join sys.database_principals as roles
	on drm.role_principal_id=roles.principal_id
where roles.type='R';

-------------------------------------------------------------------------
-- Création de role de Bases de données
USE [GESCOM]
GO
CREATE ROLE [role_test]
GO

-- Modification de role de bases de donneées
USE [GESCOM] ;
GO
ALTER ROLE [role_test] DROP MEMBER [Pierre] ;
GO

-- Suppression de role de bases de données
USE [GESCOM] ;
GO
DROP ROLE [role_test] ;

-- Création d'un role d'application
USE [GESCOM]
GO
CREATE APPLICATION ROLE [RoleTestAppli] 
WITH PASSWORD = N'Pa$$w0rd';

-- Suppression d'un role d'application
USE [GESCOM]
GO
DROP APPLICATION ROLE [RoleTestAppli] ;

-- Modification d'un role d'application
USE [GESCOM]
GO
ALTER APPLICATION ROLE [RoleTestAppli] 
WITH PASSWORD = N'Pa55w.rd';
GO

---------------------------------------------------------------
-- Corrigé exercice

ALTER LOGIN sa ENABLE;

ALTER LOGIN sa WITH PASSWORD='P@$$w0rd';

CREATE LOGIN Paul  
  WITH PASSWORD='P@$$w0rd';

USE LivreTSQL;  
GO  
CREATE USER Paul FOR LOGIN Paul;


USE LivreTSQL;  
GO  
CREATE ROLE RoleTSQL;  
GO  
GRANT CREATE TABLE, CREATE VIEW to RoleTSQL;


