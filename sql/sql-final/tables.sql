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
    start date,
    end date,
    salary double default 0,
    totalPay double default 0,
    
    totalPeriod1 double default 0,
    totalPayPeriod1 double default 0,
    totalPayedPeriod1 double default 0,
    enableMoneyPeriod1 double default 0,
    
    totalPeriod2 double default 0,
    totalPayPeriod2 double default 0,
    totalPayedPeriod2 double default 0,
    enableMoneyPeriod2 double default 0,
    
    usersFk int not null,
    FOREIGN KEY (usersFk) REFERENCES users(id),
    primary key (id)
);

create table expenditureMonth(
	id int NOT NULL AUTO_INCREMENT,
    expenditureName varchar(300),
    period int,
    expenditure double default 0,
    expenditureMonth double default 0,
    expenditureMonthPayed double default 0,
    monthPay int default 0,
    monthPayed int default 0,
    expenditureDate date,
    isPayed boolean default false,
    monthsFk int not null,
    FOREIGN KEY (monthsFk) REFERENCES months(id),
    primary key (id)
);
