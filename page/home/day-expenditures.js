
var dayExpendituresData = null;

function init() {
    getDayExpenditures1();
    getDayExpenditures2();
}

function putDayInfoTable(data,period) {
    var out = '';
    var total = 0;
    var totalPayed = 0;

    if (data !== '') {
        var resp = JSON.parse(data);
        dayExpendituresData = resp;

        for (var i = 0; i < resp.length; i++) {
            out += '<tr>' +
                    '<td>' + toUft8(resp[i].name) + '</td>' +
                    '<td class="text-center">' + resp[i].payDate + '</td>' +
                    '<td class="text-center">' + formatMoney(resp[i].cost) +' MNX</td>';

            out += '<td class="text-center">' +
                        '<button class="btn btn-info" onclick="showPerpetualModal('+ i +',0)"><i class="far fa-edit"/></button>' +
                        '<button class="btn btn-danger ml-2" onclick="showPerpetualModalErase('+ i +')"><i class="fas fa-eraser"/></button>' +
                    '</td>' + 
                '</tr>';

            total += parseFloat(resp[i].cost);
        }

        if (period == 1) { 
            $('#dayExpendituresNoInfo1').hide();
            $('#dayExpendituresTotal1').show();
            $('#dayExpenditures1').show();

            $('#dayExpenditures1').html(out);
            $('#totalDayExpenditures1').text(formatMoney(Math.round(total)) + ' MNX');
            $('#totalDividedDayExpenditures1').text(formatMoney((Math.round(total) / 2)) + ' MNX');
            $('#totalDayExpendituresPayed1').text(formatMoney(Math.round(totalPayed)) + ' MNX');
        
            $('#badge4').text(formatMoney(Math.round(total)));
        } else {
            $('#dayExpendituresNoInfo2').hide();
            $('#dayExpendituresTotal2').show();
            $('#dayExpenditures2').show();

            $('#dayExpenditures2').html(out);
            $('#totalDayExpenditures2').text(formatMoney(Math.round(total)) + ' MNX');
            $('#totalDividedDayExpenditures2').text(formatMoney((Math.round(total) / 2)) + ' MNX');
            $('#totalDayExpendituresPayed2').text(formatMoney(Math.round(totalPayed)) + ' MNX');
        
            $('#badge5').text(formatMoney(Math.round(total)));
        }

    } else {
        if (period == 1) { 
            $('#dayExpendituresNoInfo1').show();
            $('#dayExpendituresTotal1').hide();
            $('#dayExpenditures1').hide();
        } else {
            $('#dayExpendituresNoInfo2').show();
            $('#dayExpendituresTotal2').hide();
            $('#dayExpenditures2').hide();
        }
    }
}

//Service
function getDayExpenditures1() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/day/getDayExpenditure.php',
        data: {'monthsId': monthsId , 'period': 1},
        success: function (data) {
            putDayInfoTable(data,1);
        }
    });
}

function getDayExpenditures2() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/day/getDayExpenditure.php',
        data: {'monthsId': monthsId , 'period': 2},
        success: function (data) {
            putDayInfoTable(data,2);
        }
    });
}
//==============================================

init();