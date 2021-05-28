-- Envoi de mail par code TSQL
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'profiltest',  
    @recipients = 'Jacques@test.local',  
    @body = 'Envoi de mail depuis une proc�dure stock�e',  
    @subject = 'Mail applicatif' ;

-- Cr�ation d'un op�rateur de messagerie

USE [msdb]
GO
EXEC msdb.dbo.sp_add_operator @name=N'operateur_test', 
		@enabled=1, 
		@pager_days=0, 
		@email_address=N'operateur@test.local'
GO

-- Affichage des informations de l'op�rateur et modification de l'op�rateur
use msdb;
go
sp_help_operator 'operateur_test';
go
sp_update_operator 'operateur_test',
	@email_address='operateur-test@test.local';


-- Suppression de l'op�rateur

use msdb;
go
sp_delete_operator 'operateur_test' ;
go

----------------------------------------------------------------
-- Cr�ation d'un travail

USE [msdb]
GO
EXEC  msdb.dbo.sp_add_job @job_name=N'travail_test', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TEST\administrateur'


-------------------------------------------------------------------
-- Cr�ation d'alerte
use msdb;
go
exec sp_add_alert 'alerte20',
	@severity=20;

-- Activation/d�sactivation de l'alerte

use msdb;
go
exec sp_update_alert 'alerte20',
	@enabled=0;

-- Suppression de l'alerte

use msdb;
go
exec sp_delete_alert 'alerte20';

----------------------------------------------------------------------
-- Cr�ation de message SQL 
use msdb;
go
exec sp_addmessage @msgnum=50100,
	@severity=10,
	@msgtext='Sample Message',
	@lang='US_English';
exec sp_addmessage @msgnum=50100,
	@severity=10,
	@msgtext='Message d''exemple',
	@lang='French';

-- Appel d'un message
raiserror(50100,10,1);

----------------------------------------------------------------------
-- Corrig� exercice: contenu de la tache planifi�e

Delete from dbo.commandes
where date_cde<=getdate()-datepart(dy.getdate())