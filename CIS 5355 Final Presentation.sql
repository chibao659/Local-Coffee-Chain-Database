CREATE DATABASE [SummerMoon]
go

use [SummerMoon]

--ROASTER---
CREATE TABLE Roasters
(
roaster_ID int IDENTITY PRIMARY KEY,
roaster_name varchar(100) not null,
roaster_street varchar(100),
roaster_city varchar(50),
roaster_state char(2),
roaster_zip varchar(10),
roaster_country varchar(50) default 'United States',
roaster_phone varchar(15) not null
);


--SUPPLIERS--
CREATE TABLE Suppliers
(
supplier_ID int IDENTITY PRIMARY KEY,
supplier_name varchar(100) not null,
supplier_street varchar(100),
supplier_city varchar(50),
supplier_state char(2),
supplier_zip varchar(10),
supplier_country varchar(50) default 'United States',
supplier_phone varchar(15) not null
);

--ROASTERS_SUPPLIERS
CREATE TABLE roasters_suppliers_rel
(
roaster_ID int references Roasters(roaster_ID),
supplier_ID int references Suppliers(supplier_ID),
rel_descript varchar(150),
PRIMARY KEY (roaster_ID, supplier_ID)
);

--STORES--
CREATE TABLE Stores
(
store_ID int identity PRIMARY KEY,
store_street varchar(100),
store_city varchar(50),
store_state char(2),
store_zip varchar(10),
store_country varchar(50) default 'United States',
store_phone varchar(15) not null,
store_website varchar(50),
constraint store_ui1 unique(store_street,store_city,store_state)
);

--EMPLOYEES-
CREATE TABLE Employees
(
emp_ID int IDENTITY PRIMARY KEY,
emp_fname varchar(50) not null,
emp_lname varchar(50) not null,
emp_status varchar(50) not null,
emp_wage money not null,
emp_manager_ID int references Employees(emp_ID),
emp_dob date,
store_ID int references Stores(store_ID) on delete cascade not null
);

--APPLIANCES--
CREATE TABLE Appliances
(
appl_ID int IDENTITY PRIMARY KEY,
appl_name varchar(50),
appl_purchase_date date,
appl_price money not null,
supplier_ID int references Suppliers(supplier_ID) on delete cascade,
store_ID int references Stores(store_ID) on delete cascade,
);

--CUSTOMERS--
CREATE TABLE Customers
(
cus_ID int IDENTITY PRIMARY KEY,
cus_fname varchar(50),
cus_lname varchar(50),
cus_phone varchar(15),
cus_email varchar(70),
cus_reward_status varchar(30),
constraint cus_ui1 unique(cus_fname,cus_lname,cus_phone)
);

--CREDIT CARD--Although people in the business say not to do it
CREATE TABLE CustomersCredit
(
cus_ID int references Customers(cus_ID),
cus_cred_ID int IDENTITY,
cus_cred_card_num char(16) not null,
cus_cred_exp_mon smallint not null,
cus_cred_exp_year int not null,
PRIMARY KEY (cus_ID,cus_cred_ID)
);

--TRANSACTIONS
CREATE TABLE Transactions
(
tran_ID int IDENTITY PRIMARY KEY,
cus_ID int references Customers(cus_ID),
tran_date datetime default current_timestamp not null,
constraint tran_ck1 check (tran_date > '2018-01-01')
);

--PRODUCTS
CREATE TABLE Products
(
prod_ID int IDENTITY,
prod_name varchar(50) not null,
prod_descript varchar(100),
prod_unit_price money not null,
prod_qoh int,
prod_type char(1) check(prod_type='m' or prod_type = 'f' or prod_type = 'c'), --product type is M (merchandise) or F (food) or C (coffee)
supplier_ID int,
PRIMARY KEY (prod_ID),
FOREIGN KEY (supplier_ID) references Suppliers(supplier_ID),
UNIQUE(prod_type)
);

--PRODUCT_TRANSACTION
CREATE TABLE prod_tran_rel
(
prod_ID int,
tran_ID int,
prod_tran_quantity int not null,
PRIMARY KEY (prod_ID,tran_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID),
FOREIGN KEY (tran_ID) references Transactions(tran_ID)
);

--MENU
CREATE TABLE Menu
(
menu_ID int IDENTITY PRIMARY KEY,
menu_name varchar(50),
menu_tot_sections int,
);

--PROD_MENU
CREATE TABLE prod_menu_rel
(
prod_ID int,
menu_ID int,
prod_menu_descript varchar(150) --specific way to make it for the menu
PRIMARY KEY (prod_ID, menu_ID)
FOREIGN KEY (prod_ID) references Products(prod_ID),
FOREIGN KEY (menu_ID) references Menu(menu_ID)
);

--STORE_MENU
CREATE TABLE store_menu_rel
(
store_ID int,
menu_ID int,
store_menu_start_date date not null,
PRIMARY KEY (store_ID, menu_ID),
FOREIGN KEY (store_ID) references Stores(store_ID),
FOREIGN KEY (menu_ID) references Menu(menu_ID),
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
FOREIGN KEY (store_ID) references Stores(store_ID),
);

--PROD_PO_REL
CREATE TABLE Prod_PO_rel
(
prod_ID int,
PO_ID int,
prod_PO_quantity int not null,
PRIMARY KEY (prod_ID,PO_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID),
FOREIGN KEY (PO_ID) references Purchase_Orders(PO_ID),
);

--PROD_STORE_REL
CREATE TABLE Prod_Store_rel
(
prod_ID int,
store_ID int,
prod_store_spec varchar(150), --like a a difference in the recipe,
PRIMARY KEY (prod_ID,store_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID),
FOREIGN KEY (store_ID) references Stores(store_ID),
);

--Merchandise
CREATE TABLE Merchandise
(
prod_ID int,
merch_name varchar(50),
merch_size char(1) check (merch_size ='S' or merch_size ='M' or merch_size ='L' or merch_size ='XL'),
merch_material varchar(100),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID)
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
FOREIGN KEY (prod_ID) references Products(prod_ID)
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
FOREIGN KEY (roaster_ID) references Roasters(roaster_ID)
);

--Arabica
CREATE TABLE Arabica
(
prod_ID int,
A_bean_country varchar(50),
A_bean_type varchar(50),
A_bean_quality varchar(20),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID)
);

--Robusta
CREATE TABLE Robusta
(
prod_ID int,
R_bean_country varchar(50),
R_bean_type varchar(50),
R_bean_quality varchar(20),
PRIMARY KEY (prod_ID),
FOREIGN KEY (prod_ID) references Products(prod_ID)
);










--Value Insertion

insert into Customers (cus_ID, cus_fname, cus_lname, cus_phone, cus_email, cus_reward_status)
values (1,'Alene', 'Hebden', '338-651-8907', 'ahebden0@pagesperso-orange.fr','pro'),
 (2,'Karola', 'Brager', '736-680-4173', 'kbrager1@theguardian.com', 'expert'),
(3,'Andree', 'Mattingson', '106-514-4295', 'amattingson2@hud.gov','loyal'),
(4,'Garret', 'Hincks', '208-108-7638', 'ghincks3@wikipedia.org','loyal'),
(5,'Roma', 'Dosdale', '680-656-6140', 'rdosdale4@ebay.co.uk','loyal'),
(6,'Bentley', 'Broggetti', '192-646-8140', 'bbroggetti5@merriam-webster.com','pro'),
(7,'Theo', 'Gommery', '966-814-4926', 'tgommery6@ucoz.com','pro'),
(8,'Karissa', 'Philipart', '515-645-0514', 'kphilipart7@google.it','pro'),
(9,'Lenard', 'Ruddell', '336-465-6620', 'lruddell8@hubpages.com','pro'),
(10,'Gerda', 'Titterton', '146-709-9576', 'gtitterton9@webnode.com','pro')

set IDENTITY_INSERT Menu OFF

insert into Menu (menu_ID, menu_name, menu_tot_sections)
values (1,'Breakfast', 5),
(2,'lunch', 4),
(3,'Dinner', 3),
(4,'App', 4 ),
(5,'Happy', 8),
(6,'Weekend', 9),
(7,'Holiday', 3),
(8,'Weekend2', 5),
(9,'Special', 3),
(10,'Special2', 5)

set identity_insert roasters off

insert into Roasters (roaster_ID, roaster_name, roaster_street, roaster_city, roaster_state, roaster_zip, roaster_country, roaster_phone)
values (1,'Coffee express', '72 Delaware Crossing', 'Indianapolis', 'IN', '46202', 'United States', '765-399-9263'),
(2,'Opa', '4 Oneill Alley', 'Des Moines', 'IA', '50393', 'United States', '515-571-8470'),
(3,'Meanwhile', '74 Stone Corner Court', 'Lees Summit', 'MO', '64082', 'United States', '816-679-6100'),
(4,'BEans', '20067 Upham Junction', 'Hicksville', 'NY', '11854', 'United States', '516-552-6776'),
(5,'Coffee limited', '4 Forest Dale Alley', 'Detroit', 'MI', '48295', 'United States', '313-263-3121'),
(6,'Expresso', '7251 Hoffman Parkway', 'Sacramento', 'CA', '94250', 'United States', '916-594-3947'),
(7,'Coffee Roaster Inc', '663 Briar Crest Park', 'Fort Lauderdale', 'FL', '33330', 'United States', '954-832-1420'),
(8,'Roasters', '015 Vermont Pass', 'Anaheim', 'CA', '92805', 'United States', '949-735-7374'),
(9,'Coffee plus', '91249 Acker Alley', 'Charlottesville', 'VA', '22903', 'United States', '434-683-8539'),
(10,'Roaster limited', '7478 Graceland Place', 'Baltimore', 'MD', '21290', 'United States', '410-196-8211')

set identity_insert stores off

insert into Stores (store_ID, store_street, store_city, store_state, store_zip, store_country,store_phone,store_website)
values (1, '79800 Mcbride Junction', 'Austin', 'TX', '48275', 'United States', '313-821-6363', 'summermoon.com/north'),
(2, '8305 Onsgard Plaza', 'Austin', 'TX', '02162', 'United States', '508-693-4437', 'summermoon.com/lamar'),
(3, '68421 Springs Court', 'Austin', 'TX', '94237', 'United States', '916-406-9298', 'summermoon.com/mueller'),
(4, '173 Kipling Road', 'Austin', 'TX', '58122', 'United States', '701-349-9213', 'summermoon.com/downtown'),
(5, '9561 Kropf Court', 'Austin', 'TX', '47306', 'United States', '765-467-7406', 'summermoon.com/south'),
(6, '156 Anhalt Point', 'Austin', 'TX', '23612', 'United States', '757-798-4396', 'summermoon.com/soco'),
(7, '79 Shelley Way', 'Austin', 'TX', '14619', 'United States', '585-170-4862', 'summermoon.com/domain'),
(8, '914 Fulton Avenue', 'Round Rock', 'TX', '10120', 'United States', '212-419-1218', 'summermoon.com/roundrock'),
(9, '1 Randy Hill', 'Georgetown', 'TX', '10105', 'United States', '917-565-2519', 'summermoon.com/georgetown'),
(10, '4191 Garrison Court', 'Austin', 'TX', '23471', 'United States', '757-236-3662', 'summermoon.com/east')

set identity_insert suppliers off

insert into Suppliers (supplier_ID, supplier_name, supplier_street, supplier_city, supplier_state, supplier_zip,supplier_country,supplier_phone)
values (1, 'Coffee Asset  Corporation', '021 Granby Road', 'Albany', 'NY', '12237', 'United States', '518-737-1271'),
(2, 'Bean supplier', '5712 Dayton Pass', 'Fort Smith', 'AR', '72916', 'United States', '479-446-4175'),
(3, 'Versartis, Inc.', '12877 Bartillon Junction', 'Arlington', 'VA', '22244', 'United States', '571-711-9526'),
(4, 'P.A.M. Coffee Services, Inc.', '234 Northport Crossing', 'San Antonio', 'TX', '78265', 'United States', '210-285-4430'),
(5, 'Total S.A.', '8 Jana Junction', 'Anchorage', 'AK', '99507', 'United States', '907-721-9952'),
(6, 'Bean Inc.', '73258 Barby Alley', 'Washington', 'DC', '20540', 'United States', '202-637-0295'),
(7, 'Hudson Global, Inc.', '83239 Oak Valley Crossing', 'Birmingham', 'AL', '35225', 'United States', '205-249-9689'),
(8, 'Coffee Group', '60 Burrows Hill', 'Minneapolis', 'MN', '55470', 'United States', '612-421-2741'),
(9, 'Albany Coffee, Inc.', '931 Pleasure Crossing', 'Monroe', 'LA', '71213', 'United States', '318-812-6611'),
(10, 'Allegion', '68128 Declaration Place', 'Saint Paul', 'MN', '55123', 'United States', '612-393-6240')

set identity_insert products off

alter table products
drop constraint UQ__Products__94966302FFFC3D44

insert into Products (prod_ID, prod_name, prod_descript, prod_unit_price, prod_qoh, prod_type, supplier_ID)
values (1,'coffee black','coffe with no cream', 3,10,'c', 2), 
(2,'latte','espresso with milk', 5,10,'c', 3),
(3,'coffee cream','coffe with cream', 4,10,'c', 4),
(4,'tshirt','black tshirt with logo', 20,5,'m', 5),
(5,'jacket','grey jacket small logo', 40,14,'m', 6),
(6,'bannana bread','banana bread with nuts', 4.5,8,'f', 7),
(7,'pumpkin bread','pumpkin bread with nuts', 4.5,10,'f', 8),
(8,'hat','hat large logo', 15,18,'m', 9),
(9,'espresso','1 shot', 2,10,'c', 10),
(10,'americano','espresso with water', 4,10,'c', 1)




insert into Food (prod_ID, food_name, food_descript, food_cuisine, food_sell_date)
values (1,'bar','nutrition bar', 'snack', '20201210'), 
(2,'sandwhich','turkey and cheese', 'lunch', '20201210'), 
(3,'sanwhich 2','ham and cheese', 'lunch', '20201210'), 
(4,'bar 2 ','nutrition bar', 'snack', '20201210'), 
(5,'cookie','sugar cookie', 'dessert', '20201210'), 
(6,'bannana bread','banana bread with nuts', 'snack', '20201210'),
(7,'pumpkin bread','pumpkin bread with nuts', 'snack', '20201210'),
(8,'cookie 2','peanut butter cookie', 'snack', '20201210'), 
(9,'PBJ','PB and jelly sandwhich', 'lunch', '20201210'), 
(10,'apple','apple fruit', 'snack', '20201210')

set identity_insert appliances off

insert into Appliances (appl_ID, appl_name, appl_purchase_date, appl_price, supplier_ID, store_ID)
values (1,'toaster','20181009', 50,10,1), 
 (2,'fridge','20181009', 400, 9,2),
 (3,'oven','20181005', 500,8, 3),
 (4,'blender','20181009', 24,7,4),
 (5,'mixer','20181015', 78,6,5),
 (6,'freezer','20181009', 479,5,6),
 (7,'stove','20181025', 346,8,4),
 (8,'microwave','20181009', 36, 10,1),
 (9,'fryer','20181015', 78,6, 5),
 (10,'grill','20181016', 269, 1,10)

insert into Arabica(prod_ID, A_bean_country, A_bean_type, A_bean_quality)
values (1,'US','espresso',1), 
 (2,'mexico','espresso',2),
 (3,'brazil','espresso',3),
 (4,'germany','espresso',4),
 (5,'canada','espresso',5),
 (6,'UK','espresso', 6),
 (7,'spain','drip',4),
 (8,'france','drip',1),
 (9,'australia','espresso', 5),
 (10,'ireland','espresso',10)

 insert into Products (prod_ID, prod_name, prod_descript, prod_unit_price, prod_qoh, prod_type, supplier_ID)
 values (11, 'caffe machiato', 'espresso with splash of milk', 3.50, 9, 'c', 2),
 (12, 'cappuccino', 'espresso, steamed milk, and milk foam', 4.25, 12, 'c', 2),
 (13, 'iced coffee', 'coffee with ice', 3.25, 15, 'c', 6),
 (14, 'cafe au lait', 'coffee with hot milk', 3.75, 9, 'c', 6),
 (15, 'cortado', 'espresso with warm milk', 3.00, 8, 'c', 2),
 (16, 'blueberry muffin', 'muffin with blueberries', 2.50, 15, 'f', 7),
 (17, 'banana nut muffin', 'muffin with banana nuts', 2.50, 15, 'f', 7),
 (18, 'blueberry scone', 'scone with blueberries', 3.00, 10, 'f', 7),
 (19, 'bacon and egg flatbread', 'flatbread breakfast sandwich with bacon and egg', 4.50, 12, 'f', 3),
 (20, 'ham and egg flatbread', 'flatbread breakfast sandwich with ham and egg', 4.50, 12, 'f', 3),
 (21, 'apple fritter', 'baked apple pastry', 4.25, 10, 'f', 8),
 (22, 'breakfast burrito', 'bacon/sausage, egg, and cheese wrapped in tortilla', 4.75, 8, 'f', 3),
 (23, 'everything bagel', 'bagel topped with sesame seeds, poppy seeds, etc.', 3.75, 10, 'f', 3),
 (24, 'white coffee mug', 'white coffee mug with logo', 10.00, 20, 'm', 10),
 (25, 'black thermos', 'black thermos with logo', 12.00, 12, 'm', 10),
 (26, 'key chain', 'key chain with logo', 5.00, 10, 'm', 4),
 (27, 'sticker pack', 'pack of stickers with logo', 2.50, 15, 'm', 4),
 (28, 'blue thermos', 'blue thermos with logo', 12.00, 12, 'm', 10),
 (29, 'black coffee mug', 'black coffee mug with logo', 10.00, 20, 'm', 10),
 (30, 'brown coffee mug', 'brown coffee mug with logo', 10.00, 15, 'm', 10)

 delete from merchandise
 
 insert into Merchandise (prod_ID, merch_name, merch_size, merch_material)
 values (4, 'T-Shirt', 'S/M/L/XL', 'Cotton'),
 (5, 'Jacket', 'S/M/L/XL', 'Cotton Fleece'),
 (8, 'Hat', 'One Size', 'Cotton'),
 (24, 'White Coffee Mug', 'S/L', 'Ceramic'),
 (25, 'Black Thermos', 'One Size', 'Plastic'),
 (26, 'Key Chain', 'One Size', 'Metal'),
 (27, 'Sticker Pack', 'One Size', 'Paper'),
 (28, 'Blue Thermos', 'One Size', 'Plastic'),
 (29, 'Black Coffee Mug', 'S/L', 'Ceramic'),
 (30, 'Brown Coffee Mug', 'S/L', 'Ceramic')

 alter table merchandise
 drop constraint CK__Merchandi__merch__74AE54BC

 alter table merchandise
 alter column merch_size char(10)

delete from food
 
 update products
 set prod_name = 'banana bread'
 where prod_id = 6

 insert into food (prod_ID, food_name, food_descript, food_cuisine, food_sell_date)
 values (6, 'banana bread', 'banana bread with nuts', 'bread', '20201210'),
 (7, 'pumpkin bread', 'pumpkin bread with nuts', 'bread', '20201210'),
 (16, 'blueberry muffin', 'muffin with blueberries', 'muffin', '20201210'),
 (17, 'banana nut muffin', 'muffin with banana nuts', 'muffin', '20201210'),
 (18, 'blueberry scone', 'scone with blueberries', 'pastry', '20201210'),
 (19, 'bacon and egg flatbread', 'flatbread breakfast sandwich with bacon and egg', 'sandwich', '20201210'),
 (20, 'ham and egg flatbread', 'flatbread breakfast sandwich with ham and egg', 'sandwich', '20201210'),
 (21, 'apple fritter', 'baked apple pastry', 'pastry', '20201210'),
 (22, 'breakfast burrito', 'bacon/sausage, egg, and cheese wrapped in tortilla', 'wrap', '20201210'),
 (23, 'everything bagel', 'bagel topped with sesame seeds, poppy seeds, etc.', 'bread', '20201210')

 alter table coffee
 add constraint Check_Coffee_or_Espresso check (coffee_type = 'c' or coffee_type = 'e')

 insert into coffee (prod_id, coffee_type, coffee_weight, coffee_sell_date, roaster_id)
 values (1, 'c', 8.00, '20201210', 3),
 (2, 'e', 6.00, '20201210', 5),
 (3, 'c', 8.00, '20201210', 3),
 (9, 'e', 2.00, '20201210', 8),
 (10, 'e', 3.00, '20201210', 6),
 (11, 'e', 2.50, '20201210', 7),
 (12, 'e', 3.50, '20201210', 2),
 (13, 'c', 10.00, '20201210', 1),
 (14, 'c', 6.00, '20201210', 9),
 (15, 'e', 3.50, '20201210', 10)

 drop table arabica
 drop table robusta

 emp_ID int IDENTITY PRIMARY KEY,
emp_fname varchar(50) not null,
emp_lname varchar(50) not null,
emp_status varchar(50) not null,
emp_wage money not null,
emp_manager_ID int references Employees(emp_ID),
emp_dob date,
store_ID int references Stores(store_ID) on delete cascade not null

insert into Employees (emp_ID, emp_fname, emp_lname, emp_status, emp_wage, emp_manager_ID, emp_dob, store_ID)
values (1, 'Jared', 'Butler', 'Cashier', 7.50, null, '20000312', 1),
(2, 'Bailey', 'Lyles', 'Barista', 10.50, null, '19980723', 1),
(3, 'Jennifer', 'Hutchins', 'Manager', 15.00, 1, '19910220', 1),
(4, 'Tyler', 'Beckett', 'Barista', 10.50, null, '19961001', 1),
(5, 'Brooks', 'Milton', 'Cashier', 8.25, null, '20010418', 2),
(6, 'Megan', 'Terry', 'Barista', 11.00, null, '19950927', 2),
(7, 'Michael', 'Martinez', 'Manager', 16.50, 2, '19900403', 2),
(8, 'Devin', 'Smith', 'Cashier', 8.25, null, '19971206', 3),
(9, 'Nathan', 'Spellman', 'Barista', 10.75, null, '19940807', 3),
(10, 'Peyton', 'Miller', 'Manager', 17.00, 3, '19930621', 3)

insert into transactions (tran_ID, cus_ID)
values (1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10)

insert into prod_tran_rel (prod_ID, tran_ID, prod_tran_quantity)
values (4, 1, 2),
(1, 2, 1),
(19, 3, 3),
(2, 4, 1),
(27, 5, 1),
(21, 6, 2),
(5, 7, 1),
(14, 8, 1),
(8, 9, 2),
(11, 10, 1)

insert into CustomersCredit (cus_ID, cus_cred_ID, cus_cred_card_num, cus_cred_exp_mon, cus_cred_exp_year)
values (1, 1, '5602240496413629', 04, 22),
(2, 2, '3578962732334708', 10, 23),
(3, 3, '7482033847382938', 09, 21),
(4, 4, '4492837369172690', 01, 24),
(5, 5, '7899238766289932', 02, 23),
(6, 6, '4682739918273746', 05, 23),
(7, 7, '9382001928374882', 07, 24),
(8, 8, '3233998276739947', 04, 23),
(9, 9, '8793920728039112', 08, 22),
(10, 10, '7836487912760967', 11, 22)

insert into prod_menu_rel (prod_ID, menu_ID, prod_menu_descript)
values (6, 1, 'banana bread'),
(7, 1, 'pumpkin bread'),
(16, 1, 'blueberry muffin'),
(17, 1, 'banana nut muffin'),
(18, 9, 'blueberry scone'),
(19, 1, 'bacon and egg flatbread sandwich'),
(20, 1, 'ham and egg flatbread sandwich'),
(21, 9, 'apple fritter'),
(22, 1, 'breakfast burrito'),
(23, 1, 'everything bagel')

insert into Prod_Store_rel (prod_ID, store_ID, prod_store_spec)
values (4, 3, 'grey t-shirt instead of black'),
(5, 5, 'white jacket instead of grey'),
(7, 1, 'add cinnamon'),
(8, 2, 'snapback hat'),
(11, 8, 'caramel macchiato'),
(16, 4, 'chocolate chip muffin'),
(18, 9, 'strawberry scone'),
(22, 10, 'chorizo available'),
(23, 1, 'cinnamon raisin bagel'),
(24, 2, 'tye dye mug')

insert into Purchase_Orders (PO_ID, store_ID)
values (1, 3),
(2, 1),
(3, 8),
(4, 5),
(5, 6),
(6, 9),
(7, 2),
(8, 4),
(9, 7),
(10, 10)

insert into Prod_PO_rel (prod_ID, PO_ID, prod_PO_quantity)
values (1, 1, 10),
(5, 2, 14),
(8, 3, 18),
(12, 4, 12),
(16, 5, 15),
(18, 6, 10),
(22, 7, 8),
(24, 8, 20),
(25, 9, 12),
(27, 10, 15)

insert into roasters_suppliers_rel (roaster_ID, supplier_ID, rel_descript)
values (2, 4, 'coffee beans'),
(3, 1, 'espresso beans'),
(4, 5, 'espresso beans'),
(8, 2, 'coffee beans'),
(10, 8, 'coffee beans'),
(7, 3, 'coffee beans'),
(6, 9, 'milk and coffee beans'),
(9, 10, 'milk and espresso beans'),
(1, 7, 'espresso beans'),
(5, 6, 'coffee beans')

insert into store_menu_rel (store_ID, menu_ID, store_menu_start_date)
values (1, 1, '20201127'),
(1, 2, '20201128'),
(2, 1, '20201127'),
(3, 1, '20201129'),
(3, 3, '20201201'),
(4, 1, '20201130'),
(5, 1, '20201201'),
(6, 1, '20201202'),
(6, 5, '20201205'),
(7, 1, '20201203')






--Report Queries

select prod_tran_rel.prod_ID, prod_tran_rel.prod_tran_quantity as [Total Products Sold], Products.prod_name as [Product Name], Products.prod_descript as [Product Description], Products.prod_unit_price as [Product Price], (prod_tran_rel.prod_tran_quantity * Products.prod_unit_price) as [Total Sales]
from prod_tran_rel join Products
on prod_tran_rel.prod_ID = Products.prod_ID
order by prod_tran_quantity desc

select Prod_PO_rel.prod_ID, Prod_PO_rel.prod_PO_quantity as [Total Products Purchased], Products.prod_name as [Product Name], Suppliers.supplier_name as [Supplier Name], Products.prod_unit_cost [Product Cost], (Prod_PO_rel.prod_PO_quantity * Products.prod_unit_cost) as [Total Cost of Goods]
from Prod_PO_rel join Products
on Prod_PO_rel.prod_ID = Products.prod_ID join Suppliers
on Products.supplier_ID = Suppliers.supplier_ID
order by prod_PO_quantity desc