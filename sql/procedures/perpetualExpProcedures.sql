use expenditure;

drop procedure getPerpetualExpenditure;
DELIMITER //
create procedure getPerpetualExpenditure(in monthsFkP int) 
begin
	
    SELECT id,name,payDate,cost,(select sum(cost) from expenditure.perpetualexpenditure where monthsFk = monthsFkP) as total,status,monthsFk 
    FROM expenditure.perpetualexpenditure where monthsFk = monthsFkP;

end//
DELIMITER ;

drop procedure setPerpetualExpenditure;
DELIMITER //
create procedure setPerpetualExpenditure(in nameP varchar(300),in payDateP date,in costP double,in idP int,in monthsFkP int) 
begin
	
    update expenditure.perpetualexpenditure set name = nameP ,payDate = payDateP ,cost = costP where id = idP;
    
    SELECT id,name,payDate,cost,(select sum(cost) from expenditure.perpetualexpenditure where monthsFk = monthsFkP) as total,status,monthsFk 
    FROM expenditure.perpetualexpenditure where monthsFk = monthsFkP;
    
end//
DELIMITER ;

drop procedure addPerpetualExpenditure;
DELIMITER //
create procedure addPerpetualExpenditure(in nameP varchar(300),in payDateP date,in costP double,in monthsFkP int) 
begin
	
	insert into expenditure.perpetualexpenditure(name,payDate,cost,monthsFk) values(nameP,payDateP,costP,monthsFkP);
    
    SELECT id,name,payDate,cost,(select sum(cost) from expenditure.perpetualexpenditure where monthsFk = monthsFkP) as total,status,monthsFk 
    FROM expenditure.perpetualexpenditure where monthsFk = monthsFkP;
    
end//
DELIMITER ;

drop procedure deletePerpetualExpenditure;
DELIMITER //
create procedure deletePerpetualExpenditure(in idP int, in monthsFkP int) 
begin
	
	DELETE FROM expenditure.perpetualexpenditure where id = idP;
    
    SELECT id,name,payDate,cost,(select sum(cost) from expenditure.perpetualexpenditure where monthsFk = monthsFkP) as total,status,monthsFk 
    FROM expenditure.perpetualexpenditure where monthsFk = monthsFkP;
    
end//
DELIMITER ;

drop procedure checkPerpetualExpenditure;
DELIMITER //
create procedure checkPerpetualExpenditure(in idP int,in statusP boolean, in monthsFkP int) 
begin
	
	update expenditure.perpetualexpenditure set status = statusP where id = idP;
    
    SELECT id,name,payDate,cost,(select sum(cost) from expenditure.perpetualexpenditure where monthsFk = monthsFkP) as total,status,monthsFk 
    FROM expenditure.perpetualexpenditure where monthsFk = monthsFkP;
    
end//
DELIMITER ;
