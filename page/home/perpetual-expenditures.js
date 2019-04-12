
var perpetualExpendituresData = null;
var newPerpetualExpendituresData = null;
var editPerpetualExpendituresData = null;
var deletePerpetualExpendituresData = null;
var checkPerpetualExpendituresData = null;
var totalPerpetualExpenditureData = null;
var selectPerpetualExpendituresId = null;
var monthsId = getParameterByName('monthsId');
    
function init() {
    getPerpetualExpenditures();

    $("#modalPerpetualDate").datepicker({
        dateFormat: "yy-mm-dd"
    });
}

function putPerpetualInfoTable(data) {
    var out = '';
    var total = 0;
    var totalPayed = 0;

    if (data !== '') {
        var resp = JSON.parse(data);
        perpetualExpendituresData = resp;

        for (var i = 0; i < resp.length; i++) {
            out += '<tr>' +
                    '<td>' + toUft8(resp[i].name) + '</td>' +
                    '<td class="text-center">' + resp[i].payDate + '</td>' +
                    '<td class="text-center">' + formatMoney(resp[i].cost) +' MNX</td>';

            if (resp[i].status == '1') {
                out +=  '<td class="text-center">' + '<input type="checkbox" class="form-check-input" onclick="onclickperpetualModalCheck('+ i +')" checked></input>' +'</td>';
                totalPayed += parseFloat(resp[i].cost);
            } else {
                out +=  '<td class="text-center">' + '<input type="checkbox" class="form-check-input" onclick="onclickperpetualModalCheck('+ i +')"></input>' +'</td>';
            }

            out += '<td class="text-center">' +
                        '<button class="btn btn-info" onclick="showPerpetualModal('+ i +',0)"><i class="far fa-edit"/></button>' +
                        '<button class="btn btn-danger ml-2" onclick="showPerpetualModalErase('+ i +')"><i class="fas fa-eraser"/></button>' +
                    '</td>' + 
                '</tr>';

            total += parseFloat(resp[i].cost);
        }

        $('#monthPerpetualExpendituresNoInfo').hide();
        $('#monthPerpetualExpendituresTotal').show();
        $('#monthPerpetualExpenditures').show();

        $('#monthPerpetualExpenditures').html(out);
        $('#totalMonthPerpetualExpenditures').text(formatMoney(Math.round(total)) + ' MNX');
        $('#totalDividedMonthPerpetualExpenditures').text(formatMoney((Math.round(total) / 2)) + ' MNX');
        $('#totalMonthPerpetualExpendituresPayed').text(formatMoney(Math.round(totalPayed)) + ' MNX');
        $('#badge1').text(formatMoney(Math.round(total)));

        totalPerpetualExpenditureData = {'monthsId': monthsId, 'total': total, 'totalPayed': totalPayed};
        setTotalPerpetualExpenditure();

    } else {
        $('#monthPerpetualExpendituresNoInfo').show();
        $('#monthPerpetualExpendituresTotal').hide();
        $('#monthPerpetualExpenditures').hide();
    }
}

//Modal
function showPerpetualModal(id,type) {

    $('#perpetualModalTitle').text('');
    $('#modalPerpetualName').val('');
    $("#modalPerpetualDate").prop('disabled', false);
    $('#modalPerpetualDate').val('');
    $('#modalPerpetualCost').val('');


    if (type == 0) {
        var data = perpetualExpendituresData[id];
        selectPerpetualExpendituresId = perpetualExpendituresData[id].id;
        $('#perpetualModalTitle').text('Editar Gasto Perpetuo');
        $('#modalPerpetualName').val(toUft8(data.name));
        $("#modalPerpetualDate").prop('disabled', false);
        $('#modalPerpetualDate').val(data.payDate);
        $('#modalPerpetualCost').val(data.cost);
    } else {
        selectPerpetualExpendituresId = 0;
        $('#perpetualModalTitle').text('Nuevo Gasto Perpetuo');
        $("#modalPerpetualDate").prop('disabled', true);
        $("#modalPerpetualDate").val(getEndDay());
    }

    $('#perpetualModal').modal('show');

}

function onclickPerpetualModal() {
    if (isValidFrom()) {
        if (selectPerpetualExpendituresId == 0){
            newPerpetualExpendituresData = {'name': $('#modalPerpetualName').val() ,'payDate': $('#modalPerpetualDate').val() ,'cost': $('#modalPerpetualCost').val() ,'status': 0 ,'monthsId': monthsId}
            addPerpetualExpenditures();
        } else {
            editPerpetualExpendituresData = {'name': $('#modalPerpetualName').val() ,'payDate': $('#modalPerpetualDate').val() ,'cost': $('#modalPerpetualCost').val() , 'id': selectPerpetualExpendituresId ,'monthsId': monthsId}
            setPerpetualExpenditures();
        }
    }
}

function showPerpetualModalErase(id) {
    selectPerpetualExpendituresId = perpetualExpendituresData[id].id;
    $('#perpetualModalErase').modal('show');
}

function onclickperpetualModalErase() {
    deletePerpetualExpendituresData = {'id': selectPerpetualExpendituresId, 'monthsId': 1};
    deletePerpetualExpenditures();
}

function onclickperpetualModalCheck(id) {
    var data = perpetualExpendituresData[id];
    
    if (data.status == 1) {
        data.status = 0;
    } else {
        data.status = 1;
    }

    checkPerpetualExpendituresData = {'id': data.id ,'status':  data.status,'monthsId':monthsId };
    checkPerpetualExpenditures();
}

function isValidFrom() {
    out = true;

    if ($('#modalPerpetualName').val() == '') {
        $('#modalPerpetualNameHint').show();
        out = false;
    } else {
        $('#modalPerpetualNameHint').hide();
    }

    if ($('#modalPerpetualDate').val() == '') {
        $('#modalPerpetualDateHint').show();
        out = false;
    } else {
        $('#modalPerpetualDateHint').hide();
    }


    if ($('#modalPerpetualCost').val() == '') {
        $('#modalPerpetualCostHint').show();
        out = false;
    } else {
        $('#modalPerpetualCostHint').hide();
    }

    return out;
}
//===================================


//Services
function getPerpetualExpenditures() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/perpetual/getPerpetualExpenditures.php',
        data: {'monthsId': monthsId},
        success: function (data) {
            putPerpetualInfoTable(data);
        }
    });
}

function setPerpetualExpenditures() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/perpetual/setPerpetualExpenditures.php',
        data: editPerpetualExpendituresData,
        success: function (data) {
            putPerpetualInfoTable(data);
            $('#perpetualModal').modal('hide');
            warningMessage('#monthPerpetualExpendituresMessage','El gasto perpetuo ' + editPerpetualExpendituresData.name, ' ha sido editado satisfactoriamente.');
            pageTop();
        }
    });
}

function addPerpetualExpenditures() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/perpetual/addPerpetualExpenditures.php',
        data: newPerpetualExpendituresData,
        success: function (data) {
            putPerpetualInfoTable(data);
            $('#perpetualModal').modal('hide');
            infoMessage('#monthPerpetualExpendituresMessage','El gasto perpetuo ' + newPerpetualExpendituresData.name, ' ha sido creado satisfactoriamente.');
            pageTop();
        }
    });
}

function deletePerpetualExpenditures() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/perpetual/deletePerpetualExpenditures.php',
        data: deletePerpetualExpendituresData,
        success: function (data) {
            putPerpetualInfoTable(data);
            $('#perpetualModalErase').modal('hide');
            errorMessage('#monthPerpetualExpendituresMessage','Registro eliminado.','');
            pageTop();
        }
    });
}

function checkPerpetualExpenditures() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/expenditure/perpetual/checkPerpetualExpenditures.php',
        data: checkPerpetualExpendituresData,
        success: function (data) {
            putPerpetualInfoTable(data);
        }
    });
}

function setTotalPerpetualExpenditure() {
    $.ajax({
        async: false,
        type: 'post',
        url: server + '/month/setTotalPerpetualExpenditure.php',
        data: totalPerpetualExpenditureData,
        success: function (data) {}
    });
}
//======================================================================================
init();