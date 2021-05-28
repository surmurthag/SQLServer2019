-- sauvegarde complète de la base de données Gescom
BACKUP DATABASE [GESCOM] 
TO  DISK = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\Backup\GESCOM.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Complète Base de données Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Création d'une unité de sauvegarde
USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', 
	@logicalname = N'test', @physicalname = N'C:\tp\test.bak'
GO

-- Sauvegarde différentielle de la base Gescom
BACKUP DATABASE [GESCOM] 
TO  DISK = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\Backup\GESCOM.bak' 
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'GESCOM-Complète Base de données Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Sauvegarde du journal de la base Gescom
BACKUP LOG [GESCOM] 
TO  DISK = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\Backup\GESCOM.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Complète Base de données Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Mise en miroir d'une sauvegarde
BACKUP DATABASE [GESCOM] 
TO DISK = N'c:\tp\test1.bak'
mirror to DISK = N'c:\tp\test2.bak' WITH FORMAT,  
NAME = N'GESCOM-Complète Base de données Sauvegarde', STATS = 10
GO

-- Compression d'une sauvegarde
BACKUP DATABASE [GESCOM] 
TO  DISK = N'c:\tp\test1.bak' WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Complète Base de données Sauvegarde', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO

-- Sauvegarde des clé et certificat dans le cas d'une base chiffrée
BACKUP CERTIFICATE [Cert_gescom] TO FILE = 'c:\tp\sql1.cer'   
    WITH PRIVATE KEY (FILE = 'c:\tp\sql1.pvk' ,   
    ENCRYPTION BY PASSWORD = 'Pa$$w0rd' );  
GO

-- Corrigé de l'exercice: sauvegarde de la base LivreTSQL
BACKUP DATABASE [livreTSQL] 
TO DISK = N'c:\sauvegarde\livreTSQL.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'livreTSQL-Complète Base de données Sauvegarde'
GO 
