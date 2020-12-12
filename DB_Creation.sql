CREATE DATABASE [SummerMoon]
go

use [SummerMoon]

--ROASTER---
CREATE TABLE Roasters
(
roaster_ID int IDENTITY,
roaster_name varchar(100) not null,
roaster_street varchar(100),
roaster_city varchar(50),
roaster_state char(2),
roaster_zip varchar(10),
roaster_country varchar(50) default 'United States',
roaster_phone varchar(15) not null,
PRIMARY KEY (roaster_ID)
);


--SUPPLIERS--
CREATE TABLE Suppliers
(
supplier_ID int IDENTITY,
supplier_name varchar(100) not null,
supplier_street varchar(100),
supplier_city varchar(50),
supplier_state char(2),
supplier_zip varchar(10),
supplier_country varchar(50) default 'United States',
supplier_phone varchar(15) not null
PRIMARY KEY (supplier_ID)
);

--ROASTERS_SUPPLIERS
CREATE TABLE roasters_suppliers_rel
(
roaster_ID int,
supplier_ID int,
rel_descript varchar(150),
PRIMARY KEY (roaster_ID, supplier_ID),
FOREIGN KEY (roaster_ID) references Roasters(roaster_ID) on update cascade,
FOREIGN KEY (supplier_ID) references Suppliers(supplier_ID) on update cascade,
);

--STORES--
CREATE TABLE Stores
(
store_ID int IDENTITY,
store_street varchar(100),
store_city varchar(50),
store_state char(2),
store_zip varchar(10),
store_country varchar(50) default 'United States',
store_phone varchar(15) not null,
store_website varchar(50),
PRIMARY KEY (store_ID),
constraint store_ui1 unique(store_street,store_city,store_state),
);

--EMPLOYEES-
CREATE TABLE Employees
(
emp_ID int IDENTITY,
emp_fname varchar(50) not null,
emp_lname varchar(50) not null,
emp_status varchar(50) not null,
emp_wage money not null,
emp_manager_ID int,
emp_dob date,
store_ID int,
PRIMARY KEY (emp_ID),
FOREIGN KEY (store_ID) references Stores(store_ID) on delete cascade
);

--APPLIANCES--
CREATE TABLE Appliances
(
appl_ID int IDENTITY,
appl_name varchar(50),
appl_purchase_date date,
appl_price money not null,
supplier_ID int,
store_ID int,
PRIMARY KEY (appl_ID),
FOREIGN KEY (supplier_ID) references Suppliers(supplier_ID) on delete cascade,
FOREIGN KEY (store_ID) references Stores(store_ID) on delete cascade
);

--CUSTOMERS--
CREATE TABLE Customers
(
cus_ID int IDENTITY,
cus_fname varchar(50),
cus_lname varchar(50),
cus_phone varchar(15),
cus_email varchar(70),
cus_reward_status varchar(30),
PRIMARY KEY (cus_ID),
constraint cus_ui1 unique(cus_fname,cus_lname,cus_phone)
);

--CREDIT CARD--Although people in the business say not to do it
CREATE TABLE CustomersCredit
(
cus_ID int,
cus_cred_ID int IDENTITY,
cus_cred_card_num char(16) not null,
cus_cred_exp_mon smallint not null,
cus_cred_exp_year int not null,
PRIMARY KEY (cus_ID,cus_cred_ID),
FOREIGN KEY (cus_ID) references Customers(cus_ID) on update cascade
);

--TRANSACTIONS
CREATE TABLE Transactions
(
tran_ID int IDENTITY,
cus_ID int references Customers(cus_ID),
tran_date datetime default current_timestamp not null,
constraint tran_ck1 check (tran_date > '2018-01-01'),
PRIMARY KEY (tran_ID)
);

--PRODUCTS
CREATE TABLE Products
(
prod_ID int IDENTITY,
prod_name varchar(50) not null,
prod_descript varchar(100),
prod_unit_price money not null,
prod_qoh int,
prod_type char(1) check(prod_type='m' or prod_type = 'f' or prod_type = 'c'), --product type is M (merchandist) or F (food) or C (coffee)
supplier_ID int,
PRIMARY KEY (prod_ID),
FOREIGN KEY (supplier_ID) references Suppliers(supplier_ID) on update cascade,
UNIQUE(prod_type)
);

--PRODUCT_TRANSACTION
CREATE TABLE prod_tran_rel
(
prod_ID int,
tran_ID int,
prod_tran_quantity int not null,
PRIMARY KEY (prod_ID,tran_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade,
FOREIGN KEY (tran_ID) references Transactions(tran_ID) on update cascade
);

--MENU
CREATE TABLE Menu
(
menu_ID int IDENTITY,
menu_name varchar(50),
menu_tot_sections int,
PRIMARY KEY (menu_ID)
);

--PROD_MENU
CREATE TABLE prod_menu_rel
(
prod_ID int,
menu_ID int,
prod_menu_descript varchar(150) --specific way to make it for the menu
PRIMARY KEY (prod_ID, menu_ID)
FOREIGN KEY (prod_ID) references Products(prod_ID) on delete cascade on update cascade,
FOREIGN KEY (menu_ID) references Menu(menu_ID) on delete cascade
);

--STORE_MENU
CREATE TABLE store_menu_rel
(
store_ID int,
menu_ID int,
store_menu_start_date date not null,
PRIMARY KEY (store_ID, menu_ID),
FOREIGN KEY (store_ID) references Stores(store_ID) on update cascade,
FOREIGN KEY (menu_ID) references Menu(menu_ID) on update cascade on delete cascade,
constraint store_menu_start_date check (store_menu_start_date > '2018-01-01')
);

--PURCHASE_ORDERS
CREATE TABLE Purchase_Orders
(
PO_ID int IDENTITY,
PO_datetime datetime not null default current_timestamp,
PO_delivery_datetime datetime,
store_ID int,
PRIMARY KEY (PO_ID),
FOREIGN KEY (store_ID) references Stores(store_ID) on update cascade on delete cascade,
);

--PROD_PO_REL
CREATE TABLE Prod_PO_rel
(
prod_ID int,
PO_ID int,
prod_PO_quantity int not null,
PRIMARY KEY (prod_ID,PO_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade,
FOREIGN KEY (PO_ID) references Purchase_Orders(PO_ID) on update cascade,
);

--PROD_STORE_REL
CREATE TABLE Prod_Store_rel
(
prod_ID int,
store_ID int,
prod_store_spec varchar(150), --like a a difference in the recipe,
PRIMARY KEY (prod_ID,store_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade,
FOREIGN KEY (store_ID) references Stores(store_ID) on update cascade on delete cascade,
);

--Merchandise
CREATE TABLE Merchandise
(
prod_ID int,
merch_name varchar(50),
merch_size char(1) check (merch_size ='S' or merch_size ='M' or merch_size ='L' or merch_size ='XL'),
merch_material varchar(100),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade on delete cascade
);

--Food
CREATE TABLE Food
(
prod_ID int,
food_name varchar(50) not null,
food_descript varchar(200),
food_cuisine varchar(50),
food_sell_date datetime not null check(food_sell_date >= current_timestamp),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade on delete cascade
);

--COFFEE
CREATE TABLE Coffee
(
prod_ID int,
coffee_type char(1) check(coffee_type = 'a' or coffee_type = 'r'), --Arabica or Robusta
coffee_weight float,
coffee_sell_date datetime not null,
roaster_ID int,
PRIMARY KEY (prod_ID),
FOREIGN KEY (roaster_ID) references Roasters(roaster_ID) on update cascade
);

--Arabica
CREATE TABLE Arabica
(
prod_ID int,
A_bean_country varchar(50),
A_bean_type varchar(50),
A_bean_quality varchar(20),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade
);

--Robusta
CREATE TABLE Robusta
(
prod_ID int,
R_bean_country varchar(50),
R_bean_type varchar(50),
R_bean_quality varchar(20),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID) on update cascade
);