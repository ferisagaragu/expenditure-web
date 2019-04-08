use expenditure;

/*Login*/
drop procedure login;
DELIMITER //
create procedure login(in userP varchar(300), in passwordP varchar(300)) 
begin

    SELECT id,user,CONVERT(AES_DECRYPT(password,'root') USING utf8) as password,email,active,firstname,lastname FROM users where (user = userP and CONVERT(AES_DECRYPT(password,'root' )USING utf8) = passwordP)
		or (email = userP and CONVERT(AES_DECRYPT(password,'root' )USING utf8) = passwordP);

end//
DELIMITER ;

drop procedure registerUser;
DELIMITER //
CREATE PROCEDURE registerUser(in userP varchar(300),in emailP varchar(300),in passwordP varchar(300),in firstnameP varchar(300),in lastnameP varchar(300),out res int)
BEGIN
 
	set res = 0;
	if (SELECT count(*) FROM users where user = userP and email = emailP) = 0 then 
		
    insert into users(user,password,email,firstname,lastname) values(userP,AES_ENCRYPT(passwordP,'root'),emailP,firstnameP,lastnameP);
		set res = 1;
        
    end if;
 
END//
DELIMITER ;
/*=======================================*/

/*Month*/
drop procedure createMonth;
DELIMITER //
CREATE PROCEDURE createMonth(in usersFkP int)
BEGIN

	declare periodV int default 0;

	if (SELECT count(*) FROM months where name = CONCAT(MONTHNAME(DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d')),'', DATE_FORMAT(now() - interval (day(now())-1) day,'%Y')) and usersFk = usersFKP) = 0 then 
		insert into months(name,start,end,usersFk) values(CONCAT(MONTHNAME(DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d')),'', DATE_FORMAT(now() - interval (day(now())-1) day,'%Y')),DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d'),last_day(curdate()),usersFkP);
	end if;

	if DATE_FORMAT(now(),'%Y-%m-%d') <= concat(DATE_FORMAT(now(),'%Y-%m-'),'','15') then 
		set periodV = 1;
  elseif DATE_FORMAT(now(),'%Y-%m-%d') > concat(DATE_FORMAT(now(),'%Y-%m-'),'','15') and DATE_FORMAT(now(),'%Y-%m-%d') <= DATE_FORMAT(last_day(curdate()),'%Y-%m-%d') then 
		set periodV = 2;
  END IF;

	SELECT id,name,start,end,salary,totalPay,totalPeriod1,totalPayPeriod1,totalPayedPeriod1,enableMoneyPeriod1,totalPeriod2,totalPayPeriod2,totalPayedPeriod2,enableMoneyPeriod2,periodV as period FROM months where name = CONCAT(MONTHNAME(DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d')),'', DATE_FORMAT(now() - interval (day(now())-1) day,'%Y')) and usersFk = 1;
    
END//
DELIMITER ;

drop procedure updateSalary;
DELIMITER //
CREATE PROCEDURE updateSalary(in usersFkP int,in salaryP double)
BEGIN

	declare monthId int default 0;

	set monthId = (select id from months where usersFk = usersFkP and start = DATE_FORMAT(now() - interval (day(now())-1) day,'%Y-%m-%d') and end = last_day(curdate()));
	update months set salary = salaryP, totalPeriod1 = (salaryP/2), totalPeriod2 = (salaryP/2) where id = monthId;
    
END//
DELIMITER ;
/*=======================================*/

/*Expenditure*/
drop procedure registerExpenditure;
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

	select * from expendituremonth where monthsFk = idMonth;
                        
END//
DELIMITER ;

drop procedure getExpenditures;
DELIMITER //
CREATE PROCEDURE getExpenditures(in monthFkP int, in  periodP int)
BEGIN
	select * from expendituremonth where monthsFk = monthFkP and period = periodP;
END//
DELIMITER ;
/*=======================================*/