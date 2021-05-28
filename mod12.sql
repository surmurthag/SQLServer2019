-- Modification du paramètre Query Governor

set query_governor_cost_limit 20

-- ou

sp_configure 'show advanced options',1
reconfigure

sp_configure 'query governor cost limit', 20
reconfigure
-----------------------------------------------
-- Activation du Query Store

Alter database Gescom set query_store=on;
-----------------------------------------------
-- Trigger DDL
-- Création de la table utilisée dans le trigger

use GESCOM;
go

create table trigger_ddl
(id int identity,
dateheure datetime2,
utilisateur nvarchar(100),
evenement nvarchar(100),
instruction nvarchar(2000),
contexte xml);

-- création du trigger DDL
create trigger test_event_table
on database
for DDL_TABLE_EVENTS
as
insert dbo.trigger_ddl
values (getdate(),CURRENT_USER,
	EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(100)'),
	EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]','nvarchar(2000)'),
	EVENTDATA());
