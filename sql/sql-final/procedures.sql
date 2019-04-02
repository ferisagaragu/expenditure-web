use expenditure;

/*Login*/
DELIMITER //
create procedure login(in userP varchar(300), in passwordP varchar(300)) 
begin

    SELECT id,user,CONVERT(AES_DECRYPT(password,'root') USING utf8) as password,email,active,firstname,lastname FROM users where (user = userP and CONVERT(AES_DECRYPT(password,'root' )USING utf8) = passwordP)
		or (email = userP and CONVERT(AES_DECRYPT(password,'root' )USING utf8) = passwordP);

end//
DELIMITER ;

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