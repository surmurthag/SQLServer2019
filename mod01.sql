-- Lister les ID de bases de donn�es; la base courante et une base sp�cifi�es dans la commande

select db_id() as 'base courante',
	db_id('gescom') as 'Gescom'

-----------------------------------------------------------------------------------------------
-- Lister les tables et vues utilisateur d'une base de donn�es


Select *
from INFORMATION_SCHEMA.TABLES