use expenditure;

create table users(
    id int NOT NULL AUTO_INCREMENT,
    user varchar(300),
    email varchar(300),
    password blob,
    firstname varchar(300),
    lastname varchar(300),
    active boolean default '1',
    primary key (id)
);

create table months(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(300),
    startDate date,
    endDate date,
    salary double default 0,
    totalPay double default 0,
    
    totalPerpetual double default 0,
    totalPerpetualPayed double default 0,
    
    totalMonth double default 0,
    totalMonthPayed double default 0,
    
    totalEndMonth double default 0,
    totalEndMonthPayed double default 0,
    
    totalEnableMoney1 double default 0,
    totalPayedMoney1 double default 0,
    
    totalEnableMoney2 double default 0,
    totalPayedMoney2 double default 0,

    totalBorrowedMoney double default 0,
    totalBorrowedMoneyPayed double default 0,

    totalCardBorrowed double default 0,
    totalCardBorrowedPayed double default 0,

    usersFk int not null,
    FOREIGN KEY (usersFk) REFERENCES users(id),
    primary key (id)
);

create table monthExpenditure(
	id int NOT NULL AUTO_INCREMENT,
    name varchar(300),
    payMonth int,
    payedMonth int,
    totalCost double default 0,
    payDate date,
    cost double default 0,
    status boolean default false,
    monthsFk int not null,
    FOREIGN KEY (monthsFk) REFERENCES months(id),
    primary key (id)
);

create table perpetualExpenditure(
	id int NOT NULL AUTO_INCREMENT,
    name varchar(300),
    payDate date, 
    cost double default 0,
    status boolean default false,
    monthsFk int not null,
    FOREIGN KEY (monthsFk) REFERENCES months(id),
    primary key (id)
);

create table dayExpenditure(
	id int NOT NULL AUTO_INCREMENT,
    name varchar(300),
    payDate date, 
    cost double default 0,
    period int,
    monthsFk int not null,
    FOREIGN KEY (monthsFk) REFERENCES months(id),
    primary key (id)
);
