$(document).ready(function() {
  var $centileform     = $("#centileform")
      $weight          = $("#weight"),
      $height          = $("#height"),
      $dayofbirth      = $("#dayofbirth"),
      $monthofbirth    = $("#monthofbirth"),
      $yearofbirth     = $("#yearofbirth"),
      $sex             = $("#sex"),
      $calculatebutton = $("#calculatebutton");

  $centileform.submit(function(e) {
    var address = (function() {
      var hostname = window.location.hostname;

      return hostname.length === 0 ? "http://cc.jackwilsdon.me" : hostname
    })();

    $.getJSON(address + ":4567/centile?jsonp_callback=?", {
      weight_in_kg: $weight.val(),
      height_in_m: $height.val(),
      day_of_birth: $dayofbirth.val(),
      month_of_birth: $monthofbirth.val(),
      year_of_birth: $yearofbirth.val(),
      sex: $sex.val()
    }, function(response) {
      console.log(response);
    });

    return false;
  });
});
