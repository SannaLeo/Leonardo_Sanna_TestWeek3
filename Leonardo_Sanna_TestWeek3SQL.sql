use master;
GO
create database Pizzeria;
GO
use Pizzeria;

create table Ingrediente(
IdIngrediente int constraint PK_Ingrediente primary key,
NomeIngrediente varchar(30) not null,
Prezzo money not null constraint CK_PrezzoI check(Prezzo > 0),
QtaMagazzino int not null constraint CK_Magazzino check(QtaMagazzino >= 0)
)

create table Pizza(
IdPizza int constraint PK_Pizza primary key identity(1,1),
NomePizza varchar(30) not null,
Prezzo money not null constraint CK_PrezzoP check(Prezzo > 0)
)

create table IngredientePizza(
Pizza int not null,
Ingrediente int not null,
constraint UQ_IP unique(Pizza, Ingrediente),
constraint FK_IPPizza foreign key (Pizza) references Pizza(IdPizza),
constraint FK_IPIngrediente foreign key (Ingrediente) references Ingrediente(IdIngrediente)
)

-------------------------------------------------------------INSERT-------------------------------------------------------------
insert into Ingrediente values(1, 'Pomodoro', 0.5, 10)
insert into Ingrediente values(2, 'Mozzarella', 0.5, 30)
insert into Ingrediente values(3, 'Mozzarella di Bufala', 1.5, 10)
insert into Ingrediente values(4, 'Spianata Piccante', 1, 3)
insert into Ingrediente values(5, 'Funghi', 1, 2)
insert into Ingrediente values(6, 'Carciofi', 1, 3)
insert into Ingrediente values(7, 'Prosciutto Cotto', 1.5, 2)
insert into Ingrediente values(8, 'Olive', 1, 5)
insert into Ingrediente values(9, 'Funghi Porcini', 1.5, 1)
insert into Ingrediente values(10, 'Stracchino', 1, 4)
insert into Ingrediente values(11, 'Speck', 1.5, 2)
insert into Ingrediente values(12, 'Rucola', 0.5, 2)
insert into Ingrediente values(13, 'Grana', 1.5, 2)
insert into Ingrediente values(14, 'Verdure di Stagione', 1.5, 4)
insert into Ingrediente values(15, 'Patate', 1, 3)
insert into Ingrediente values(16, 'Salsiccia', 1.5, 10)
insert into Ingrediente values(17, 'Pomodorini', 1, 3)
insert into Ingrediente values(18, 'Ricotta', 1.5, 2)
insert into Ingrediente values(19, 'Provola', 1.5, 4)
insert into Ingrediente values(20, 'Gorgonzola', 1.5, 2)
insert into Ingrediente values(21, 'Pomodoro Fresco', 1, 2)
insert into Ingrediente values(22, 'Basilico', 0.5, 2)
insert into Ingrediente values(23, 'Bresaola', 1.5, 10)
insert into Ingrediente values(24, 'Verdure Miste', 1.5, 4)
-------------------------------------------------------------QUERY-------------------------------------------------------------
--1. Estrarre pizze prezzo > 6
select NomePizza, Prezzo
from Pizza
where Prezzo > 6

--2. Estrarre la/le pizza/e più costosa/e
select NomePizza, Prezzo
from Pizza
where Prezzo in (select max(Prezzo) from Pizza)

--3. Estrarre le pizze bianche
select NomePizza, p.Prezzo
from Pizza p
where IdPizza not in (select Pizza
						from IngredientePizza inpi
						where inpi.Ingrediente in (select IdIngrediente
													from Ingrediente i
													where i.NomeIngrediente='Pomodoro'))

--4 Estrarre le pizze che contengono funghi
select NomePizza, p.Prezzo
from Pizza p
where IdPizza in (select Pizza
						from IngredientePizza inpi
						where inpi.Ingrediente in (select IdIngrediente
													from Ingrediente i
													where i.NomeIngrediente like 'Funghi%'))

-------------------------------------------------------------PROCEDURE-------------------------------------------------------------
--1
create procedure InserisciPizza
@Nome varchar(30),
@Prezzo money
as
insert into Pizza values (@Nome, @Prezzo);

execute InserisciPizza 'MARGHERITA' , 5.00;
execute InserisciPizza 'BUFALA' , 7.00;
execute InserisciPizza 'DIAVOLA' , 6.00;
execute InserisciPizza 'QUATTRO STAGIONI' , 6.50;
execute InserisciPizza 'PORCINI' , 7.00;
execute InserisciPizza 'DIONISO' , 8.00;
execute InserisciPizza 'ORTOLANA' , 8.00;
execute InserisciPizza 'PATATE E SALSICCIA' , 6.00;
execute InserisciPizza 'POMODORINI' , 6.00;
execute InserisciPizza 'QUATTRO FORMAGGI' , 7.50;
execute InserisciPizza 'CAPRESE' , 7.50;
execute InserisciPizza 'ZEUS' , 7.50;

select*from Pizza;
select*from Ingrediente;

--2
create procedure InserisciIngredientePizza
@nomePizza varchar(30),
@nomeIngrediente varchar(30)
as
begin
	declare @idPizza int
	declare @idIngrediente int

	select @idPizza=p.IdPizza
	from Pizza as p 
	where p.NomePizza=@nomePizza

	select @idIngrediente=IdIngrediente
	from Ingrediente i 
	where i.NomeIngrediente=@nomeIngrediente

	insert into IngredientePizza values (@idPizza, @idIngrediente);
end

--execute
/* 
select*from IngredientePizza
execute InserisciIngredientePizza 'MARGHERITA', 'Pomodoro';
execute InserisciIngredientePizza 'MARGHERITA', 'Mozzarella';
execute InserisciIngredientePizza 'BUFALA', 'Pomodoro';
execute InserisciIngredientePizza 'BUFALA', 'Mozzarella di Bufala';
execute InserisciIngredientePizza 'DIAVOLA', 'Pomodoro';
execute InserisciIngredientePizza 'DIAVOLA', 'Mozzarella';
execute InserisciIngredientePizza 'DIAVOLA', 'Spianata Piccante';
execute InserisciIngredientePizza 'QUATTRO STAGIONI', 'Pomodoro';
execute InserisciIngredientePizza 'QUATTRO STAGIONI', 'Mozzarella';
execute InserisciIngredientePizza 'QUATTRO STAGIONI', 'Funghi';
execute InserisciIngredientePizza 'QUATTRO STAGIONI', 'Carciofi';
execute InserisciIngredientePizza 'QUATTRO STAGIONI', 'Prosciutto';
execute InserisciIngredientePizza 'QUATTRO STAGIONI', 'Olive';
execute InserisciIngredientePizza 'PORCINI', 'Pomodoro';
execute InserisciIngredientePizza 'PORCINI', 'Mozzarella';
execute InserisciIngredientePizza 'PORCINI', 'Funghi Porcini';
execute InserisciIngredientePizza 'DIONISO', 'Pomodoro';
execute InserisciIngredientePizza 'DIONISO', 'Mozzarella';
execute InserisciIngredientePizza 'DIONISO', 'Stracchino';
execute InserisciIngredientePizza 'DIONISO', 'Speck';
execute InserisciIngredientePizza 'DIONISO', 'Rucola';
execute InserisciIngredientePizza 'DIONISO', 'Grana';
execute InserisciIngredientePizza 'ORTOLANA', 'Pomodoro';
execute InserisciIngredientePizza 'ORTOLANA', 'Mozzarella';
execute InserisciIngredientePizza 'ORTOLANA', 'Verdure di Stagione';
execute InserisciIngredientePizza 'PATATE E SALSICCIA', 'Mozzarella';
execute InserisciIngredientePizza 'PATATE E SALSICCIA', 'Patate';
execute InserisciIngredientePizza 'PATATE E SALSICCIA', 'Salsiccia';
execute InserisciIngredientePizza 'POMODORINI', 'Mozzarella';
execute InserisciIngredientePizza 'POMODORINI', 'Pomodorini';
execute InserisciIngredientePizza 'POMODORINI', 'Ricotta';
execute InserisciIngredientePizza 'QUATTRO FORMAGGI', 'Mozzarella';
execute InserisciIngredientePizza 'QUATTRO FORMAGGI', 'Provola';
execute InserisciIngredientePizza 'QUATTRO FORMAGGI', 'Grana';
execute InserisciIngredientePizza 'QUATTRO FORMAGGI', 'Gorgonzola';
execute InserisciIngredientePizza 'CAPRESE', 'Pomodoro Fresco';
execute InserisciIngredientePizza 'CAPRESE', 'Mozzarella';
execute InserisciIngredientePizza 'CAPRESE', 'Basilico';
execute InserisciIngredientePizza 'ZEUS', 'Mozzarella';
execute InserisciIngredientePizza 'ZEUS', 'Bresaola';
execute InserisciIngredientePizza 'ZEUS', 'Rucola';
*/ 

--3


create procedure AggiornaPrezzoPizza
@NomePizza varchar(30),
@NuovoPrezzo money
as
declare @idPizza int
select @idPizza=IdPizza
from Pizza
where NomePizza=@NomePizza
update Pizza
set Pizza.Prezzo=@NuovoPrezzo
where Pizza.IdPizza=@idPizza


--4
create procedure EliminaIngredientePizza
@NomePizza varchar(30),
@NomeIngrediente varchar(30)
as
begin
	declare @idPizza int
	declare @idIngrediente int

	select @idPizza=IdPizza
	from Pizza p 
	where p.NomePizza=@NomePizza

	select @idIngrediente=IdIngrediente
	from Ingrediente i 
	where i.NomeIngrediente=@NomeIngrediente

	delete from IngredientePizza
	where Pizza=@idPizza and Ingrediente=@idIngrediente
end


--5
create procedure IncrementoPrezzoPerIngrediente
@NomeIngrediente varchar(30)
as
begin
	declare @idPizza int
	declare @idIngrediente int


	select @idIngrediente=IdIngrediente
	from Ingrediente i 
	where i.NomeIngrediente=@NomeIngrediente

	update Pizza
	set Prezzo=Prezzo*1.1
	where Pizza.IdPizza in
	(
		select inpi.Pizza
		from IngredientePizza as inpi
		where inpi.Ingrediente=@idIngrediente
	)
end

select*from Pizza
execute IncrementoPrezzoPerIngrediente 'Mozzarella di Bufala'
select*from Pizza

-------------------------------------------------------------FUNZIONI-------------------------------------------------------------
--1. Listino pizze 
create function ListinoPizze()
returns table
as
Return
select NomePizza, Prezzo
from Pizza

select* from ListinoPizze()

--3 Listino pizze con ingrediente
create function ListinoPizzeIngrediente(@Ingrediente varchar(30))
returns table
as
Return
select NomePizza, Prezzo
from Pizza
where IdPizza in (select Pizza 
						from IngredientePizza
						where Ingrediente in (select IdIngrediente
												from Ingrediente
												where NomeIngrediente=@Ingrediente))

select* from ListinoPizzeIngrediente('Pomodoro')


--3 Listino pizze senza ingrediente
create function ListinoPizzeSenzaIngrediente(@Ingrediente varchar(30))
returns table
as
Return
select NomePizza, p.Prezzo
from Pizza p
where p.IdPizza not in (select Pizza
						from IngredientePizza inpi
						where inpi.Ingrediente in (select IdIngrediente
													from Ingrediente i
													where i.NomeIngrediente = @Ingrediente ))

select* from ListinoPizzeSenzaIngrediente('Pomodoro')


--4 Calcolo numero Pizze contenenti ingrediente
create function ContaPizzeConIngrediente(@Ingrediente varchar(30))
returns int
as
begin
declare @countpizze int
select @countpizze=count(*)
from Pizza p
where p.IdPizza in (select Pizza
						from IngredientePizza inpi
						where inpi.Ingrediente in (select IdIngrediente
													from Ingrediente i
													where i.NomeIngrediente = @Ingrediente))
return @countpizze
end


select dbo.ContaPizzeConIngrediente ('pomodoro') as PizzeConBufala


--5 Calcolo numero Pizze senza ingrediente
create function ContaPizzeSenzaIngrediente(@Ingrediente varchar(30))
returns int
as
begin
declare @countpizze int
select @countpizze=count(*)
from Pizza p
where p.IdPizza not in (select Pizza
						from IngredientePizza inpi
						where inpi.Ingrediente in (select IdIngrediente
													from Ingrediente i
													where i.NomeIngrediente = @Ingrediente))
return @countpizze
end

select dbo.ContaPizzeSenzaIngrediente ('pomodoro') as [Pizze Bianche]

--6 Calcolo numero ingredienti contenuti in una pizza
create function ContaIngredientiInPizza(@Pizza varchar(30))
returns int
as
begin
declare @countingrediente int
select @countingrediente=count(*)
from Ingrediente i
where i.IdIngrediente in (select Ingrediente
						from IngredientePizza inpi
						where inpi.Pizza in (select IdPizza
													from Pizza p
													where p.NomePizza = @Pizza))
return @countingrediente
end

select dbo.ContaIngredientiInPizza('Quattro formaggi')

-------------------------------------------------------------VIEW-------------------------------------------------------------
--versione normale
create view ListinoPizzeCompleto as(
select p.NomePizza, p.Prezzo
from Pizza p
)

--verione con concatenamento
create view ListinoPizzeCompleto as(
select p.NomePizza, p.Prezzo, ((select string_agg(i.NomeIngrediente, ', ') 
										from Ingrediente i 
											where i.IdIngrediente in (select inpi.Ingrediente
																		from IngredientePizza inpi
																			where inpi.Pizza=p.IdPizza))) as 'Ingredienti'
from Pizza p
)
