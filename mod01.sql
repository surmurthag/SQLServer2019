-- Lister les ID de bases de données; la base courante et une base spécifiées dans la commande

select db_id() as 'base courante',
	db_id('gescom') as 'Gescom'

-----------------------------------------------------------------------------------------------
-- Lister les tables et vues utilisateur d'une base de données


Select *
from INFORMATION_SCHEMA.TABLES