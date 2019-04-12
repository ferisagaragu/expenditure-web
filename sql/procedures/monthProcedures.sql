use expenditure;

drop procedure setTotalPerpetualExpenditure;
DELIMITER //
create procedure setTotalPerpetualExpenditure(in monthsFkP int ,in total double, in totalPayed double) 
begin
	
	update months set totalPerpetual = total ,totalPerpetualPayed = totalPayed where id = monthsFkP;

end//
DELIMITER ;

drop procedure setTotalDayExpenditure;
DELIMITER //
create procedure setTotalDayExpenditure(in monthsFkP int ,in period int ,in total double, in totalPayed double) 
begin
	
    if period = 1 then 
        update months set totalEnableMoney1 = total ,totalPayedMoney1 = totalPayed where id = monthsFkP;
    elseif period = 2 then
        update months set totalEnableMoney2 = total ,totalPayedMoney2 = totalPayed where id = monthsFkP;
	end if;

end//
DELIMITER ;