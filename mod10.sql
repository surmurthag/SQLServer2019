-- cr�ation d'un compteur personnalis� pour l'analyseur de performance

create proc MonCompteur
as
begin
	declare @n int;
	select @n = COUNT(*)
		from GESCOM.dbo.CLIENTS;
	exec sp_user_counter1 @n;
end

exec MonCompteur
