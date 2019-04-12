use expenditure;

drop procedure getMonthExpenditure;
DELIMITER //
create procedure getMonthExpenditure(in monthsFkP int) 
begin
	
    select id,name,payMonth,payedMonth,totalCost,payDate,cost,status,monthsFk from monthexpenditure where monthsFk = monthsFkP;

end//
DELIMITER ;