#testing tab 2

drop database test_event_company;

create database test_event_company
default character set utf8
collate utf8_polish_ci;

use test_event_company;

drop table all_events;

create table all_events (
id_event int primary key auto_increment,
id_client int,
event_name varchar(55) not null,
event_date date not null,
organized_0_upcoming_1 bool default 1, ####################################jaki rodzaj danej??? wyświetlenie ma się opierać na triggerze
employee_responsible_1 int,
main_supplier int,
value_of_event double(12,2),
foreign key (employee_responsible_1) references employee (id_e),
foreign key (main_supplier) references suppliers (id_supplier),
foreign key (id_client) references clients (id_client)
);

insert into all_events values (default, 1, 'Volvo dla rodziny', '2019-09-01', 1, 1, 1, 150000);
insert into all_events values (default, 3, 'Dni Gianta', '2020-04-15', 1, 2, 1, 250000);
insert into all_events values (default, 2, 'Premiera nowej Nokii', '2020-01-10', 1, 3, 1, 50000);
insert into all_events values (default, 4, 'Zlot kibiców United', '2019-08-10', 0, 1, 1, 20000);
insert into all_events values
(default, 5, 'Koncert IKEA dla pracowników', '2018-06-01', 0, 2, 3, 80000),
(default, 6, 'Święto odkurzacza', '2019-10-10', 1, 6, 3, 30000);

select*from all_events;





drop table employee;

CREATE TABLE employee (
    id_e INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(55) NOT NULL,
    lastname VARCHAR(55) NOT NULL,
    birth_date DATE NOT NULL,
    empl_date 		DATETIME DEFAULT NOW(),
    salary_net    	DOUBLE(8 , 2 ) NOT NULL,
    department ENUM('Sprzedaż', 'Organizacja', 'Zarząd', 'Kadry', 'Księgowość') NOT NULL,
    activity BOOL DEFAULT 1,
    email VARCHAR(55) UNIQUE,
    password VARCHAR(55) NOT NULL
);

insert into employee values 
(default, 'Kamil', 'Kawecki', '1990-02-01', '2018-06-05', 4600, 'Sprzedaż', default, 'k.kawecki@event.pl', '123456');
insert into employee values (default, 'Paweł', 'Stołowy', '1991-03-01', '2014-06-05', 5000, 'Sprzedaż', default, 'p.stolowy@event.pl', '111111');
insert into employee values (default, 'Sebastian', 'Osiedlowy', '1994-02-09', '2018-06-01', 3800, 'Organizacja', default, 's.osiedlowy@event.pl', '222222');
insert into employee values
(default, 'Konrad', 'Pernak', '1995-05-16', '2017-03-05', 4500, 'Organizacja', default, 'k.pernak@event.pl', '333333'),
(default, 'Tomasz', 'Kross', '1988-08-21', '2014-03-05', 6000, 'Organizacja', default, 't.kross@event.pl', '444444'),
(default, 'Mateusz', 'Zmywarkowski', '1986-07-01', '2013-02-01', 12000, 'Zarząd', default, 'm.zmywarkowski@event.pl', '55555'),
(default, 'Tymon', 'Wiatrak', '1987-02-20', '2013-02-01', 12000, 'Zarząd', default, 't.wiatrak@event.pl', '6666'),
(default, 'Monika', 'Kawecka', '1991-09-09', '2018-06-05', 4500, 'Kadry', default, 'm.kawecka@event.pl', '77777'),
(default, 'Elżbieta', 'Parkietowa', '1981-11-01', '2013-08-05', 5000, 'Księgowość', default, 'e.parkietowa@event.pl', '88888');

select*from employee;







drop table clients;

create table clients (
id_client int primary key auto_increment,
company_name varchar(55) not null,
id_e_account_manager int not null default 1,
foreign key (id_e_account_manager) references employee (id_e)
);

insert into clients values (default, 'Volvo', 1);
insert into clients values (default, 'Nokia', 2);
insert into clients values (default, 'Giant', 3);
insert into clients values (default, 'Manchester United', 1);
insert into clients values
(default, 'IKEA', 6),
(default, 'Zelmer', 7),
(default, 'Jeronimo Martins', 1),
(default, 'Nike', 2),
(default, 'Świat roślin', 2);








create table suppliers (
id_supplier int primary key auto_increment,
suppliers_name varchar (55) not null,
type_of_service enum ('Pracownicy', 'Dzwięk', 'VJs', 'Transport', 'Dobra materialne') not null,
email varchar (55) unique,
phone_number varchar (12)
);

insert into suppliers values (default, 'TransJan', 'Transport', 'transjan@wp.pl', '600540520');
insert into suppliers values
(default, 'VisualPro', 'VJs', 'visualpro@visualpro.pl', '500243932'),
(default, 'Sound 4u', 'Dzwięk', 'biuro@sound4u.pl', '697617734'),
(default, 'Work Agency', 'Pracownicy', 'pracownicy@workagency.pl', '587465891'),
(default, 'StuffRental', 'Dobra materialne', 'wypozyczalnia@stuffrental.pl', '600578431');

select*from suppliers;






#Zaszyfrowanie hasła
update employee set password = md5(password);
select id_e, lastname, password from employee;

#Zapytania
select * from employee where empl_date > '2016-01-01';
select * from employee where salary_net > 5000;
select * from all_events where organized_0_upcoming_1 = 0;
select * from all_events where employee_responsible_1 = 1;

select 
	* 
from 
	all_events 
where
	event_date > '2020-01-01'
		and 
	value_of_event >= 6000;
    
select id_e, name, lastname, salary_net from employee where salary_net > 10000;
update employee set salary_net=salary_net+1000;

#Widoki
create or replace view nadchodzace_eventy
as select id_event, event_name, id_client, event_date from all_events where organized_0_upcoming_1=1;

create or replace view płace
as select name, lastname, salary_net from employee;

create or replace view wartość_przyszłych_eventów
as select sum(value_of_event) as wartość_przyszłych_eventów from all_events where organized_0_upcoming_1=1;

create or replace view wartość_zorganizowanych_eventów
as select sum(value_of_event) as wartość_zorganizowanych_eventów from all_events where organized_0_upcoming_1=0;

create or replace view lista_pracowników
as select name, lastname, department from employee;

select*from nadchodzace_eventy;
select*from płace;
select*from wartość_przyszłych_eventów;
select*from wartość_zorganizowanych_eventów;
select*from lista_pracowników;


delimiter //
create trigger event_01 after update on all_events
for each row
begin
if event_date > curdate()
	set new.organized_0_upcoming_1 = 0;
end //
delimiter ;



















