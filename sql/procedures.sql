use expenditure;

DELIMITER //
create procedure login(in userP varchar(300), in passwordP varchar(300)) 
begin

    SELECT id,user,CONVERT(AES_DECRYPT(password,'root') USING utf8) as password,email,active,firstname,lastname FROM users where (user = userP and CONVERT(AES_DECRYPT(password,'root' )USING utf8) = passwordP)
		or (email = userP and CONVERT(AES_DECRYPT(password,'root' )USING utf8) = passwordP);

end//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registerUser(in userP varchar(300),in emailP varchar(300),in passwordP varchar(300),in firstnameP varchar(300),in lastnameP varchar(300),out res boolean)
BEGIN
 
	set res = false;
	if (SELECT count(*) FROM users where user = userP) = 0 then 
		
    insert into users(user,password,emailP,firstname,lastname) values(userP,AES_ENCRYPT(passwordP,'root'),emailP,firstnameP,lastnameP);
		set res = true;
        
  end if;
 
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE disableUser(in idP int,in activeP boolean, out res boolean)
BEGIN
 
	set res = false;
    update users set active = activeP where id = idP;
    
	if (SELECT count(*) FROM users where id = idP and active = activeP) = 1 then 
		set res = true;
    end if;
 
END//
DELIMITER ;




DELIMITER //
CREATE PROCEDURE createMonth(in usersFkP int)
BEGIN
	
	if (SELECT count(*) FROM months where name = CONCAT(MONTHNAME(DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d')),'', DATE_FORMAT(now() - interval (day(now())-1) day,'%Y')) and usersFk = usersFKP) = 0 then 
		insert into months(name,start,end,usersFk) values(CONCAT(MONTHNAME(DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d')),'', DATE_FORMAT(now() - interval (day(now())-1) day,'%Y')),DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d'),last_day(curdate()),usersFkP);
    end if;
    
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE updateSalary(in usersFkP int,in salaryP double)
BEGIN
	
	update months set salary = salaryP, totalPeriod1 = (salaryP/2), totalPeriod2 = (salaryP/2) where usersFk = usersFkP;
    
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE calculeExpenditures(in usersFkP int)
BEGIN
	
    declare totalServices double default 0;
    declare totalServicesDiv double default 0;
    declare enableMoney double default 0;
    declare monthId int default 0;
    
    set monthId = (select id from months where usersFk = usersFkP and start = DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d') and end = last_day(curdate()));
    
    set totalServices = (select round(sum(expenditureMonth)) from expendituremonth where monthsFk =  2 and monthPay = -1);
    set totalServices = totalServices + (select round(sum(expenditureMonth)) from expendituremonth where monthsFk = monthId and monthPay = -2 and expenditureDate < CONCAT(DATE_FORMAT(now(),'%Y-%m-'),'',20) and expendituremonth.expenditureDate > concat(DATE_FORMAT(now() - interval (day(now()) + 1) day,'%Y-%m-'),'','20'));
    set totalServices = totalServices + (select sum(expenditureMonth) from expendituremonth where monthsFk = monthId and monthPay > 1 and expenditureDate < CONCAT(DATE_FORMAT(now(),'%Y-%m-'),'',20) and expendituremonth.expenditureDate > concat(DATE_FORMAT(now() - interval (day(now()) + 1) day,'%Y-%m-'),'','20'));
    set totalServicesDiv = round(totalServices / 2);
    
    set enableMoney = (select salary from months where id = monthId) / 2;
	set enableMoney = enableMoney - totalServicesDiv;

	/*se cargan los pagos mensuales permanentes*/
	update months set totalPay = totalServices, totalPayPeriod1 = totalServicesDiv, totalPayPeriod2 = totalServicesDiv,
					  enableMoneyPeriod1 = enableMoney, enableMoneyPeriod2 = enableMoney where id = monthId;
    /*=========================================*/
    
END//
DELIMITER ;




DELIMITER //
CREATE PROCEDURE registerExpenditure(in usersFkP int,in expenditureNameP varchar(300),in expenditureP double,in monthPayP double)
BEGIN
	
    declare periodV int default 0;
    declare idMonth int default 0;
    declare money double default 0;
    declare money2 double default 0;
    
    if DATE_FORMAT(now(),'%Y-%m-%d') <= concat(DATE_FORMAT(now(),'%Y-%m-'),'','15') then 
		set periodV = 1;
    elseif DATE_FORMAT(now(),'%Y-%m-%d') > concat(DATE_FORMAT(now(),'%Y-%m-'),'','15') and DATE_FORMAT(now(),'%Y-%m-%d') <= DATE_FORMAT(last_day(curdate()),'%Y-%m-%d') then 
		set periodV = 2;
    END IF;
	
    set idMonth = (select id from months where usersFk = usersFkP and start = DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d') and end = last_day(curdate()));
    
    if monthPayP = 1 then 
    
		insert into expendituremonth(expenditureName,period,expenditure,expenditureMonth,expenditureMonthPayed,monthPay,monthPayed,expenditureDate,monthsFk) 
						values(expenditureNameP,periodV,expenditureP,expenditureP,expenditureP,1,1,now(),idMonth);
		
		if periodV = 2 then 
			set money = (select enableMoneyPeriod1 from months where id = idMonth);
            set money2 = (select totalPayPeriod2 from months where id = idMonth);
			update months set enableMoneyPeriod1 = (money - expenditureP), totalPayPeriod2 = (money2 + expenditureP) where id = idMonth;
        end if;
        
    elseif monthPayP = 0 then 
    
		insert into expendituremonth(expenditureName,period,expenditure,expenditureMonth,expenditureMonthPayed,monthPay,monthPayed,expenditureDate,monthsFk) 
						values(expenditureNameP,periodV,expenditureP,expenditureP,expenditureP,0,0,now(),idMonth);
    
		if periodV = 1 then 
			set money = (select enableMoneyPeriod1 from months where id = idMonth);
			update months set enableMoneyPeriod1 = money - expenditureP where id = idMonth;
        end if; 
        
        if periodV = 2 then 
			set money = (select enableMoneyPeriod2 from months where id = idMonth);
			update months set enableMoneyPeriod2 = money - expenditureP where id = idMonth;
        end if;
        
    elseif monthPayP = -1 then
    
		insert into expendituremonth(expenditureName,period,expenditure,expenditureMonth,expenditureMonthPayed,monthPay,expenditureDate,monthsFk) 
						values(expenditureNameP,periodV,expenditureP,expenditureP,0,monthPayP,now(),idMonth);
                        
    elseif monthPayP = -2 then
    
		insert into expendituremonth(expenditureName,period,expenditure,expenditureMonth,expenditureMonthPayed,monthPay,expenditureDate,monthsFk) 
						values(expenditureNameP,periodV,expenditureP,expenditureP,0,monthPayP,now(),idMonth);
                        
	else 
    
		insert into expendituremonth(expenditureName,period,expenditure,expenditureMonth,expenditureMonthPayed,monthPay,expenditureDate,monthsFk) 
						values(expenditureNameP,periodV,expenditureP,(expenditureP/monthPayP),0,monthPayP,now(),idMonth);
                        
	end if;
                        
END//
DELIMITER ;


