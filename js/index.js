function init() {

    $('#loginBtn').click( function(evt) {
        console.log('dio click');
        console.log({'user':$('#userNameTxt').val(), 'password':$('#passwordTxt').val()});
        $.post( "http://localhost/expenditure-web/res/user/login.php", {'user':$('#userNameTxt').val(), 'password':$('#passwordTxt').val()})
            .done(function( data ) {
                window.open("page/principal/home.html");
            }
        );
    });


} 
init();