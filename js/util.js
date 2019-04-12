function getDate() {
    var d = new Date();
    var month = d.getMonth()+1;
    var day = d.getDate();
    var output = d.getFullYear() + '/' +
    (month<10 ? '0' : '') + month + '/' +
    (day<10 ? '0' : '') + day; 
    return output;
}

function getFirstDay() {
  var date = new Date();
  var primerDia = new Date(date.getFullYear(), date.getMonth(), 1);

  if (primerDia.getDate() <= 9) {
    return getDate().substring(0,8) + '0' + primerDia.getDate();
  } else {
    return getDate().substring(0,8) + primerDia.getDate();
  }
}

function getEndDay() {
  var date = new Date();
  var primerDia = new Date(date.getFullYear(), date.getMonth() +1, 0);

  if (primerDia.getDate() <= 9) {
    return getDate().substring(0,8) + '0' + primerDia.getDate();
  } else {
    return getDate().substring(0,8) + primerDia.getDate();
  }
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
      d = d == undefined ? "." : d,
      t = t == undefined ? "," : t,
      s = n < 0 ? "-" : "",
      i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
      j = (j = i.length) > 3 ? j % 3 : 0;
  
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
  };

function toUft8(data) {
    return data.replace('u00e1','á')
               .replace('u00ed','í');
}

function infoMessage(id, assent, message) {
  $(id).html( $(id).html() + 
      '<div class="alert alert-info alert-dismissible fade show" role="alert">' +
          '<strong>'+ assent +'</strong>' + message +
          '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
              '<span aria-hidden="true">&times;</span>' +
          '</button>' +
      '</div>'
  );
}

function errorMessage(id, assent, message) {
  $(id).html( $(id).html() + 
      '<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
          '<strong>'+ assent +'</strong>' + message +
          '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
              '<span aria-hidden="true">&times;</span>' +
          '</button>' +
      '</div>'
  );
}

function warningMessage(id, assent, message) {
  $(id).html( $(id).html() + 
      '<div class="alert alert-warning alert-dismissible fade show" role="alert">' +
          '<strong>'+ assent +'</strong>' + message +
          '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
              '<span aria-hidden="true">&times;</span>' +
          '</button>' +
      '</div>'
  );
}

function pageTop() {
  $('body, html').animate({
    scrollTop: '0px'
  }, 300);
}

function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
  results = regex.exec(location.search);
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

$('.floatFilter').keypress(function(eve) {
  if ((eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0)) {
    eve.preventDefault();
  }

  // this part is when left part of number is deleted and leaves a . in the leftmost position. For example, 33.25, then 33 is deleted
  $('.floatFilter').keyup(function(eve) {
    if ($(this).val().indexOf('.') == 0) {
      $(this).val($(this).val().substring(1));
    }
  });
});