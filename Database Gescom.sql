Le script peut s’exécuter avec des erreurs, mais ceci est dû à la génération aléatoire des lignes de commande. 
Cela ne vous empêchera pas de disposer de la base de données Gescom.




CREATE DATABASE GESCOM
GO
USE GESCOM
GO
CREATE TABLE ARTICLES(
	REFERENCE_ART nvarchar(16) NOT NULL,
	DESIGNATION_ART nvarchar(200) NULL,
	PRIXHT_ART decimal(10, 2) NULL,
	CODE_CAT int NULL,
	prixttc  AS (prixht_art*(1.196)) PERSISTED,
 CONSTRAINT pk_articles PRIMARY KEY (REFERENCE_ART),
 CONSTRAINT uq_des_prix UNIQUE NONCLUSTERED (
	DESIGNATION_ART ASC,
	PRIXHT_ART ASC)
);
GO
CREATE TABLE CATEGORIES(
	code_cat int IDENTITY(100,1) NOT NULL,
	libelle_cat nvarchar(200) NULL,
 CONSTRAINT pk_categories PRIMARY KEY(code_cat)
);
GO
CREATE TABLE CLIENTS(
	numero int NOT NULL,
	nom nvarchar(30) NOT NULL CONSTRAINT df_nom  DEFAULT ('anonyme'),
	prenom nvarchar(30) NOT NULL,
	adresse nvarchar(80) NULL,
	codepostal char(5) NULL,
	ville nvarchar(30) NULL,
	telephone char(14) NOT NULL,
	CODEREP char(2) NOT NULL,
	ca numeric(10, 2) NULL,
	gps geography NULL,
 CONSTRAINT pk_clients PRIMARY KEY (numero)
) ;
GO
CREATE TABLE COMMANDES(
	numero_cde int IDENTITY(1,1) NOT NULL,
	date_cde date NULL,
	taux_remise numeric(2, 0) NULL,
	numero_cli int NULL,
	etat_cde char(2) NULL,
 CONSTRAINT PK_COMMANDES PRIMARY KEY (numero_cde)
);
GO
GO
CREATE TABLE HISTO_FAC(
	numero_fac int IDENTITY(1000,1) NOT NULL,
	date_fac datetime NULL,
	numero_cde int NULL,
	montantht smallmoney NULL,
	etat_fac char(2) NULL,
	CONSTRAINT pk_histo_fac PRIMARY KEY (numero_fac)
);
GO
CREATE TABLE LIGNES_CDE(
	numero_cde int NOT NULL,
	numero_lig int NOT NULL,
	reference_art nvarchar(16) NOT NULL,
	qte_cde int NULL DEFAULT ((1)),
	CONSTRAINT PK_LIGNES_CDE PRIMARY KEY(numero_cde,numero_lig)
);
GO
CREATE TABLE STOCKS(
	REFERENCE_ART nvarchar(16) NOT NULL,
	DEPOT char(2) NOT NULL,
	QTE_STK int NULL,
	STOCK_MINI int NULL DEFAULT ((0)),
	STOCK_MAXI int NULL,
	CONSTRAINT pk_stocks PRIMARY KEY(REFERENCE_ART,DEPOT)
);
GO
ALTER TABLE ARTICLES  ADD  CONSTRAINT fk_articles_categories FOREIGN KEY(CODE_CAT)
REFERENCES CATEGORIES (code_cat)
ON UPDATE CASCADE;
GO
ALTER TABLE ARTICLES CHECK CONSTRAINT fk_articles_categories;
GO
ALTER TABLE COMMANDES ADD  CONSTRAINT fk_commandes_clients FOREIGN KEY(numero_cli)
REFERENCES CLIENTS(numero);
GO
ALTER TABLE HISTO_FAC ADD  CONSTRAINT FK_HISTO_FAC_COMMANDES FOREIGN KEY(numero_cde)
REFERENCES COMMANDES (numero_cde);
GO
ALTER TABLE LIGNES_CDE ADD  CONSTRAINT FK_LIGNES_CDE_ARTICLES FOREIGN KEY(reference_art)
REFERENCES ARTICLES (REFERENCE_ART);
GO
ALTER TABLE LIGNES_CDE ADD  CONSTRAINT FK_LIGNES_CDE_COMMANDES FOREIGN KEY(numero_cde)
REFERENCES COMMANDES (numero_cde);
GO
ALTER TABLE STOCKS ADD  CONSTRAINT fk_stocks_articles FOREIGN KEY(REFERENCE_ART)
REFERENCES ARTICLES (REFERENCE_ART);
GO
ALTER TABLE ARTICLES ADD  CONSTRAINT ck_articles_prixht CHECK  (prixht_art>=0);
GO
ALTER TABLE CLIENTS ADD  CONSTRAINT ck_clients_codepostal CHECK  
  ((CONVERT(int,codepostal)>=(1000) AND CONVERT(int,codepostal)<=(95999)));
GO
PRINT 'Ajouter des Clients'
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(0,'DOE','John','rue des inconnus','56300','Verdun','05 56 28 29 30','OO');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(1,'Acajou','Albert','rue des accacias','15000','Aurillac','04 15 27 28 29','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(2,'Burma','Barnabé','rue des brasseurs','29000','Brest','02 29 26 27 28','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(3,'Cinquante','Cécile','rue des cerises','14000','Caen','02 14 24 25 26','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(4,'Delatour','Daniel','rue des Dahlias','21000','Dijon','05 21 23 24 25','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(5,'Etcha','Ernest','rue des Eglantiers','27000','Evreux','02 27 22 23 24','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(6,'François','Fernande','rue des fleurs','09000','Foix','04 09 21 22 23','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(7,'Gorjo','Gaëlle','rue des Géraniums','05000','Gap','04 05 20 21 22','AB');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(8,'Hirman','Hector','rue des Hortensias','67500','Haguenau','','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(9,'Irina','Irène','rue des Iris','37140','Ingrandes','','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(10,'Jana','Jean','rue des jonquilles','07160','Jaunac','04 06 08 10 12','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(11,'Kornu','Karine','rue des Kiwis','22480','Kerpert','02 02 03 03 04','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(12,'Loubet','Leon','rue des lilas','69000','Lyon','04 05 06 07 08','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(13,'Moleron','Marc','rue des massifs','13000','Marseille','04 05 03 06 02','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(14,'Noloir','Noémie','rue Nationale','44000','Nantes','02 01 03 01 04','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(15,'Ontira','Octave','rue des Ormes','45000','Orléans','02 04 06 08 10','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(16,'Piono','Pascal','rue de la poissonière','75000','Paris','01 02 03 04 05','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(17,'Quarante','Quentin',null,'29000','Quimper','02 10 12 14 16','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(18,'Rosetta','Remy','rue des roses','35000','Rennes','02 35 01 03 04','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(19,'Soixante','Sandrine','rue des senteurs','67000','Strasbourg','05 67 10 11 12','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(20,'Trente','Teddy','rue des Tamaris','37000','Tours','02 37 11 12 13','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(21,'Ugnace','Urbain','rue des Utriculaires','73400','Ugine','04 73 12 13 14','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(22,'VingtDeux','Valérie',null,'26000','Valence','04 26 13 14 15','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(23,'Willy','Wilfried','rue des Wasabis','08270','Wagnon','05 08 14 15 16','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(24,'Xudoct','Xavier',null,'54800','Xonville','05 54 15 16 17','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(25,'Yvres','Yann','rue des yuccas','43200','Yssingeaux','04 43 16 17 18','CD');
insert into clients (numero,nom, prenom, adresse, codepostal, ville,telephone, coderep) values(26,'Zazou','Zoé','rue des Zinnia','59123','Zuydcoote','05 59 17 18 19','CD');

PRINT 'Ajouter des categories'
set identity_insert categories on
insert into categories (code_cat, libelle_cat) values (10,'Imprimantes');
insert into categories (code_cat, libelle_cat) values (20,'Scanners');
insert into categories (code_cat, libelle_cat) values (30,'Claviers');
insert into categories (code_cat, libelle_cat) values (40,'Souris');
insert into categories (code_cat, libelle_cat) values (50,'Clés USB');
set identity_insert categories off
go
PRINT 'Ajouter des articles'
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('IMP01','Canon LBP 6200d',109.9,10);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('IMP02','Canon LBP-7200Cdn',299.9,10);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('IMP03','Canon LBP-5050n',189.9,10);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('IMP04','Epson WorkForce Pro',159.99,10);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('IMP05','Brother HL4140-CN',269.90,10);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SCA06','Canon Lide 210',83.90,20);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SCA07','Canon P-150',269.90,20);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SCA08','Fujitsu fi-5530C2',3059.89,20);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SCA09','Epson Perfection V750 Pro',519.90,20);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SCA10','Epson Perfection V600',269.90,20);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLA11','Logitech G19',131.89,30);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLA12','Logitech DiNovo Mini',79.99,30);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLA13','Microsoft Arc Keyboard',42.95,30);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLA14','Microsft Digital Media Keyboard',22.90,30);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLA15','Razer Black Window',74.89,30);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SOU16','Logitech G500',44.99,40);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SOU17','Microsoft Comfort Mouse 4500',15.89,40);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SOU18','Logitech M185 Wireless Mouse',14.95,40);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SOU19','Logitech M235 Wireless Mouse',18.90,40);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('SOU20','Microsoft Touch Mouse',59.90,40);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLE21','Corsair Flash Voyager',35.99,50);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLE22','Lexar Echo MX',14.99,50);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLE23','Kingston DTR500',23.99,50);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLE24','LaCie XtremMey',39.99,50);
insert into ARTICLES (REFERENCE_ART,DESIGNATION_ART, PRIXHT_ART, CODE_CAT) VALUES('CLE25','Scandisk Cruzer Edge',10.49,50);
go
Print 'Mise en place fonction obtenirReferenceArticle'
go
create function obtenirReferenceArticle(@indice int) returns nvarchar(16) as
begin
  declare @reference nvarchar(16);
  declare @i int;
  declare carticles cursor for select reference_art from articles;
  
  
  set @i=1;
  open carticles;
  fetch carticles into @reference;
  while (@@fetch_status=0 and @i<@indice) begin
	fetch carticles into @reference;
	set @i=@i+1;
  end;
  close carticles;
  deallocate carticles;
  return @reference;
end;
go
Print 'Mise en place procédure ajouteDetailcommande'
go
create procedure ajouteDetailCommande (@commande int) as
begin
  declare @nombreLignes int;
  declare @iligne int;
  declare @qte int;
  declare @reference nvarchar(16)
  -- Nombre de lignes:
  select @nombreLignes=cast(RAND()*100 as int)%10;
  if (@nombreLignes=0) set @nombreLignes=1;
  set @iligne=1;
  while (@iligne<=@nombreLignes) begin
	-- obtenir une reference article
	select @reference=dbo.obtenirReferenceArticle(cast(rand()*100000 as int)%25);
	-- calculer la quantite
	select @qte=cast(rand()*10 as int)%10;
	if (@qte=0) set @qte=1;
	-- insérer la ligne
	insert into dbo.LIGNES_CDE(numero_cde, numero_lig, reference_art, qte_cde) values(@commande, @iligne, @reference, @qte)
	-- passer à la ligne suivante
	set @iligne=@iligne+1;
  end;
end;
go
PRINT 'Ajouter des commandes'
-- ajouter des commandes au hasard environ 100
-- tirage au sort de la date = date et heur courante
-- tirage au sort du client
declare @client int;
-- tirage au sort de l'etat
declare @etat char(2);
declare @tirageEtat int;
declare @taux_remise int =0;
declare @i int=0;
declare @numero int;
while (@i<100) begin
	select @tirageEtat=cast(RAND()*10 as int)%3;
	if (@tirageEtat=0) set @etat='EC';
	if (@tirageEtat=1) set @etat='LI';
	if (@tirageEtat=2) set @etat='SO';
	-- Le client
	select @client=cast(RAND()*100000 as int)%26;
	-- ajouter la commande
	insert into commandes(date_cde, taux_remise,numero_cli, etat_cde)
	values (getdate(), 0, @client, @etat);
	-- retrouver le numero de la commande
	select @numero=@@identity;
	-- ajouter des lignes de commandes
	exec dbo.ajouteDetailcommande @numero; 
	-- Message
	Print 'Commande ajoutée'
	-- Au suivant
	set @i=@i+1;
end;
go
Print 'Ajout de lignes de commandes'
-- Parcourir toutes les commandes
declare cajout cursor for select numero_cde from commandes;
declare @numero int;
open cajout;
fetch cajout into @numero;
while (@@FETCH_STATUS=0) begin
  exec dbo.ajouteDetailcommande @numero
  fetch cajout into @numero;
end;
close cajout;
deallocate cajout;

go
Print 'Ajout des historiques de facture'

insert into HISTO_FAC(numero_cde, montantht, date_fac, etat_fac)
SELECT c.numero_cde,  sum(l.qte_cde*a.prixht_art), getdate(), c.etat_cde
from  COMMANDES c inner join LIGNES_CDE l on l.numero_cde=c.numero_cde
inner join ARTICLES a on a.REFERENCE_ART=l.reference_art
group by c.numero_cde,c.etat_cde;

Print 'Ajouter des stocks'
insert into stocks (reference_art, depot, qte_stk)
 select reference_art, 'N',20 FROM ARTICLES;
 insert into stocks (reference_art, depot, qte_stk)
 select reference_art, 'P1',50 FROM ARTICLES;
-- Parcourir toutes les commandes 
declare cQte cursor for select reference_art, sum(qte_cde) as qte from LIGNES_CDE group by reference_art;
declare @ref nvarchar(16);
declare @qte int;
open cQte;
fetch cQte into @ref, @qte;
while (@@FETCH_STATUS=0) begin
  update stocks set qte_stk=qte_stk-@qte where reference_art=@ref;
  fetch cQte into @ref, @qte;
end;
close cQte;
deallocate cQte;
go
update stocks
set qte_stk=qte_stk*-1
where qte_stk<0;
go
