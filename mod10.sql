-- création d'un compteur personnalisé pour l'analyseur de performance

create proc MonCompteur
as
begin
	declare @n int;
	select @n = COUNT(*)
		from GESCOM.dbo.CLIENTS;
	exec sp_user_counter1 @n;
end

exec MonCompteur
