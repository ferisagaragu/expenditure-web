use expenditure;

drop procedure getDayExpenditure;
DELIMITER //
create procedure getDayExpenditure(in monthsFkP int,in periodP int) 
begin
	
    select id,name,payDate,cost,period,monthsFk from dayexpenditure where monthsFk = monthsFkP and period = periodP;

end//
DELIMITER ;