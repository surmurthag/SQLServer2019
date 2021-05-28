-- Lister les utilisateurs connectés

select login_name,program_name,database_id,host_name 
from sys.dm_exec_sessions
where is_user_process=1

-- Placer la base Gescom en mode mono utilisateur

USE [master]
GO
ALTER DATABASE [GESCOM] SET  SINGLE_USER WITH NO_WAIT
GO

-- sauvegarde du journal de transaction (si la base n'est pas en mode simple)
-- avant de faire une restauration
BACKUP LOG [GESCOM] 
TO  DISK = N'c:\tp\test1.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'GESCOM-Complète Base de données Sauvegarde', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Restauration de la base Gescom depuis l'unité testSQL et en outrepassant le controle de sécurité (with REPLACE)
USE Master ;
go
RESTORE DATABASE GESCOM 
FROM testSQL WITH  FILE = 1,  NOUNLOAD,  REPLACE, STATS = 5
GO

-- Restauration de 2 jeu de sauvegarde de la base Gescom (complète puis différentielle) 
-- les 2 jeu sont stockés sur la même unité de sauvegarde et sélectionner avec l'option WITH FILE
RESTORE DATABASE GESCOM FROM testSQL WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE GESCOM FROM testSQL WITH  FILE = 2,  RECOVERY, NOUNLOAD,  STATS = 5

-- Restauration de 4 jeu de sauvegarde de la base Gescom (complète puis différentielle et LOG)
RESTORE DATABASE GESCOM FROM testSQL WITH FILE = 1, NORECOVERY, NOUNLOAD,  STATS = 5
RESTORE DATABASE GESCOM FROM testSQL WITH FILE = 2, NORECOVERY, NOUNLOAD,  STATS = 5
RESTORE LOG GESCOM FROM testSQL WITH FILE = 3, NORECOVERY, NOUNLOAD,  STATS = 5
RESTORE LOG GESCOM FROM testSQL WITH FILE = 4, NOUNLOAD, STATS = 5


-- Utilisation de l'option STOPAT sur la restauration du dernier journal
RESTORE DATABASE GESCOM FROM testSQL WITH FILE = 1, NORECOVERY, NOUNLOAD, STATS = 5
RESTORE DATABASE GESCOM FROM testSQL WITH FILE = 2, NORECOVERY, NOUNLOAD, STATS = 5
RESTORE LOG GESCOM FROM testSQL WITH FILE = 3, NORECOVERY, NOUNLOAD, STATS = 5
RESTORE LOG GESCOM FROM testSQL WITH FILE = 4, NOUNLOAD, STATS = 5, STOPAT = N'2020-05-21T16:06:00'


-- Restauration des clé et certificat nécessaire à une sauvegarde de base chiffrée
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
go

CREATE CERTIFICATE [Cert_gescom]   
    FROM FILE = 'c:\tp\sql1.cer'   
    WITH PRIVATE KEY (FILE = 'c:\tp\sql1.pvk',   
    DECRYPTION BY PASSWORD = 'Pa$$w0rd');  
GO

-- Corrigé de l'exercice de restauration de la base exemple Adventureworks2017
restore database adventureworks2017
from disk='c:\tp\adventureworks2017.bak' 
with move 'AdventureWorks2017' to 'c:\tp\AdventureWorks2017.mdf',
	move 'AdventureWorks2017_log' to 'c:\tp\AdventureWorks2017.ldf'

