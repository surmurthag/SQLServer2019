-- afficher le classement du serveur

select SERVERPROPERTY('collation');

-----------------------------------------------------------------
-- Lister tous les classements disponibles

select * 
from ::fn_helpcollations();

-----------------------------------------------------------------
-- Modifier le mot de passe de la connexion sa

USE [master]
GO
ALTER LOGIN [sa] WITH PASSWORD=N'Pa55w.rd'
GO
-----------------------------------------------------------------
-- Configurer l'acc�s aux options de configuration �tendues
-- afin de modifier la quantit� de m�moire minimum du serveur
-- et le niveau de priorit� de SQL Server

EXEC sys.sp_configure N'show advanced options', N'1'  
go
RECONFIGURE 
GO
EXEC sys.sp_configure N'min server memory (MB)', N'2048'
GO
RECONFIGURE 

EXEC sys.sp_configure N'priority boost', 1
GO
RECONFIGURE

-----------------------------------------------------------------
-- Cr�ation d'un catalogue pour index de texte int�gral
use gescom;
go

create fulltext catalog cataloguelivre
with accent_sensitivity=off
as default;

-- Cr�ation d'un index de texte int�gral sur ce catalogue
create fulltext index on dbo.articles(designation_art)
key index pk_articles
on cataloguelivre;
go
-- Cr�ation d'une liste de mots vides
CREATE FULLTEXT STOPLIST listemotsvides
FROM SYSTEM STOPLIST;
go
-- Modification de cette liste
ALTER FULLTEXT STOPLIST [listemotsvides] 
ADD 'livre' LANGUAGE 'French';
GO

-- Utilisation de l'index de texte int�gral

select *
from dbo.ARTICLES
where contains(DESIGNATION_ART,'Microsoft');
