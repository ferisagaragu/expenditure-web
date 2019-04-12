
var monthExpendituresData = null;
var monthsId = getParameterByName('monthsId');

function init() {
    //getMonthExpenditures();
}

function putMonthInfoTable(data) {
    var out = '';
    var total = 0;
    var totalPayed = 0;

    if (data !== '') {
        var resp = JSON.parse(data);
        monthExpendituresData = resp;

        for (var i = 0; i < resp.length; i++) {
            out += '<tr>' +
                        '<td>' + toUft8(resp[i].name) + '</td>' +
                        '<td class="text-center">' + resp[i].payMonth + '</td>' +
                        '<td class="text-center">' + resp[i].payedMonth + '</td>' +
                        '<td class="text-center">' + resp[i].totalCost + '</td>' +
                        '<td class="text-center">' + resp[i].payDate + '</td>' +
                        '<td class="text-center">' + formatMoney(resp[i].cost) +' MNX</td>';

            if (resp[i].status == '1') {
                out +=  '<td class="text-center">' + '<input type="checkbox" class="form-check-input" onclick="" checked></input>' +'</td>';
                totalPayed += parseFloat(resp[i].cost);
            } else {
                out +=  '<td class="text-center">' + '<input type="checkbox" class="form-check-input" onclick=""></input>' +'</td>';
            }

            out += '<td class="text-center">' +
                        '<button class="btn btn-info" onclick=""><i class="far fa-edit"/></button>' +
                        '<button class="btn btn-danger ml-2" onclick=""><i class="fas fa-eraser"/></button>' +
                    '</td>' + 
                '</tr>';

            total += parseFloat(resp[i].cost);
        }

        $('#monthExpendituresNoInfo').hide();
        $('#monthExpendituresTotal').show();
        $('#monthExpenditures').show();

        $('#monthExpenditures').html(out);
        $('#totalMonthExpenditures').text(formatMoney(Math.round(total)) + ' MNX');
        $('#totalDividedMonthExpenditures').text(formatMoney((Math.round(total) / 2)) + ' MNX');
        $('#totalMonthExpendituresPayed').text(formatMoney(Math.round(totalPayed)) + ' MNX');
        $('#badge2').text(formatMoney(Math.round(total)));

    } else {
        $('#monthExpendituresNoInfo').show();
        $('#monthExpendituresTotal').hide();
        $('#monthExpenditures').hide();
    }
}

//Petitions
function getMonthExpenditures() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/month/getMonthExpenditure.php',
        data: {'monthsId': monthsId},
        success: function (data) {
            putMonthInfoTable(data);
        }
    });
}
//===========================

init();