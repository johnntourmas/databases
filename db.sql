drop table if exists vehicles cascade;
drop table if exists vehicles_info cascade;

drop table if exists drivers cascade;
drop table if exists drivers_info cascade;

drop table if exists address_info cascade;

drop table if exists customers cascade;
drop table if exists contracts cascade;

drop table if exists drivers_violations cascade;
drop table if exists violations_info cascade;


drop type if exists vehicle_type cascade;
drop type if exists gen cascade;
drop type if exists group_ cascade;
drop type if exists category cascade;

create type gen as enum('M','F');
create type vehicle_type as enum('car','motorcycle','track');
create type group_ as enum('private','professional','mixed use');
create type category as enum('active','not active');

create table vehicles(
    license_plate varchar(30) primary key,
    frame_number char(17) not null unique,
    model_id varchar(15) not null,
	color varchar(50) not null,
    category vehicle_type not null default 'car'
);

create table vehicles_info(
    model_id varchar(15) primary key,
    model varchar(200) not null,
	first_release numeric(4) not null,
    brand varchar(50) not null,
    price int not null check(price > 0)
);

create table customers(
    customer_id varchar(10) primary key,
    full_name varchar(50) not null,
    gender gen not null default 'M',
    birthday date not null,
    phone_number varchar(30),
    cell_phone varchar(30),
    email varchar(100),
    address_id varchar(50) not null,
    check(phone_number != null or cell_phone != null),
	check(DATE_PART('year', current_date) - DATE_PART('year', birthday) >= 18)
);

create table drivers_info (
    license_number varchar(50) not null primary key,
    full_name varchar(50) not null,
    gender gen not null default 'M',
    birthday date not null,
    address_id varchar(30) not null
);

create table address_info(
    address_id varchar(15) primary key,
    zip_code varchar(20) not null,
    country varchar(100) not null,
    city varchar(100) not null,
    street varchar(200) not null
);

create table drivers (
    license_number varchar(50) not null,
    license_plate varchar(30) not null,
    primary key (license_number, license_plate)
);

create table contracts(
    contract_code varchar(50) primary key,
	license_plate varchar(30) not null unique,
    contract_group group_ not null,
    cost decimal(100,2) not null check(cost > 0), 
    start_date date not null,
    end_date date not null,
    customer_id varchar(10) not null,
    contract_category category,
	check(start_date < end_date)
);

create table drivers_violations(
	violation_id varchar(10) not null,
    license_number varchar(50) not null,
    license_plate varchar(30) not null,
	primary key (violation_id, license_number, license_plate)
);

create table violations_info(
    violation_id varchar(10) primary key,
    violation_code varchar(10) not null,
    date_time timestamp not null,
    description varchar(300) not null
);

alter table vehicles
    add foreign key(model_id)
    references vehicles_info(model_id)
    on delete cascade;


alter table drivers
    add foreign key(license_plate)
    references vehicles(license_plate)
    on delete cascade;

alter table drivers
    add foreign key(license_plate)
    references contracts(license_plate)
    on delete cascade;

alter table drivers
    add foreign key(license_number)
    references drivers_info(license_number)
    on delete cascade;

alter table drivers_info
    add foreign key(address_id)
    references address_info(address_id)
    on delete cascade;

alter table customers
    add foreign key(address_id)
    references address_info(address_id)
    on delete cascade;

alter table contracts
	add foreign key(license_plate)
	references vehicles(license_plate)
	on delete cascade;

alter table contracts
	add foreign key(customer_id)
	references customers(customer_id)
	on delete cascade;

alter table drivers_violations
	add foreign key(license_plate, license_number)
	references drivers(license_plate, license_number)
	on delete cascade;

alter table drivers_violations
	add foreign key(violation_id)
	references violations_info(violation_id)
	on delete cascade;



