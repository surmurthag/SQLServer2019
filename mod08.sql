-- sauvegarde compl�te de la base de donn�es Gescom
BACKUP DATABASE [GESCOM] 
TO  DISK = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\Backup\GESCOM.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Compl�te Base de donn�es Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Cr�ation d'une unit� de sauvegarde
USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', 
	@logicalname = N'test', @physicalname = N'C:\tp\test.bak'
GO

-- Sauvegarde diff�rentielle de la base Gescom
BACKUP DATABASE [GESCOM] 
TO  DISK = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\Backup\GESCOM.bak' 
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'GESCOM-Compl�te Base de donn�es Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Sauvegarde du journal de la base Gescom
BACKUP LOG [GESCOM] 
TO  DISK = N'C:\Program Files\Microsoft SQL Ser-ver\MSSQL15.MSSQLSERVER\MSSQL\Backup\GESCOM.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Compl�te Base de donn�es Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Mise en miroir d'une sauvegarde
BACKUP DATABASE [GESCOM] 
TO DISK = N'c:\tp\test1.bak'
mirror to DISK = N'c:\tp\test2.bak' WITH FORMAT,  
NAME = N'GESCOM-Compl�te Base de donn�es Sauvegarde', STATS = 10
GO

-- Compression d'une sauvegarde
BACKUP DATABASE [GESCOM] 
TO  DISK = N'c:\tp\test1.bak' WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Compl�te Base de donn�es Sauvegarde', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO

-- Sauvegarde des cl� et certificat dans le cas d'une base chiffr�e
BACKUP CERTIFICATE [Cert_gescom] TO FILE = 'c:\tp\sql1.cer'   
    WITH PRIVATE KEY (FILE = 'c:\tp\sql1.pvk' ,   
    ENCRYPTION BY PASSWORD = 'Pa$$w0rd' );  
GO

-- Corrig� de l'exercice: sauvegarde de la base LivreTSQL
BACKUP DATABASE [livreTSQL] 
TO DISK = N'c:\sauvegarde\livreTSQL.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'livreTSQL-Compl�te Base de donn�es Sauvegarde'
GO 
