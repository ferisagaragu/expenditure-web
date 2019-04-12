//BARRA DE DINERO
var totalFinal = 0;
function moneyBars(salary,total) {
    totalFinal += Math.round(total);
    $('#percentageMoney').css('width',(totalFinal * 100 / salary) + '%');
    $('#percentageMoney').text(formatMoney(totalFinal) + ' MNX');
    $('#totalMoney').css('width',((salary - totalFinal) * 100 / salary) + '%');
    $('#totalMoney').text(formatMoney((salary - totalFinal)) + ' MNX');

    $('#percentageMoney1').css('width',((totalFinal/2) * 100 / (salary / 2)) + '%');
    $('#percentageMoney1').text(formatMoney((totalFinal/2)) + ' MNX');
    $('#totalMoney1').css('width',(((salary / 2) - (totalFinal/2)) * 100 / (salary / 2)) + '%');
    $('#totalMoney1').text(formatMoney(((salary / 2) - (totalFinal/2))) + ' MNX');

    $('#percentageMoney2').css('width',((totalFinal/2) * 100 / (salary / 2)) + '%');
    $('#percentageMoney2').text(formatMoney((totalFinal/2)) + ' MNX');
    $('#totalMoney2').css('width',(((salary / 2) - (totalFinal/2)) * 100 / (salary / 2)) + '%');
    $('#totalMoney2').text(formatMoney(((salary / 2) - (totalFinal/2))) + ' MNX');
}

function moneyBarsLess(salary,total,bar) {
    var monthMoney = ((salary / 2) - (totalFinal/2));
    var totalFinalVar = (salary - totalFinal);
    
    $('#totalMoney').css('width',((totalFinalVar - total) * 100 / salary) + '%');
    $('#totalMoney').text(formatMoney((totalFinalVar - total)) + ' MNX');

    if (bar == 1) {
        $('#totalMoney1').css('width',(( monthMoney - total) * 100 / (salary / 2)) + '%');
        $('#totalMoney1').text((monthMoney - total) + ' MNX');
    } else {
        $('#totalMoney2').css('width',(( monthMoney - total) * 100 / (salary / 2)) + '%');
        $('#totalMoney2').text((monthMoney - total) + ' MNX');
    }

}