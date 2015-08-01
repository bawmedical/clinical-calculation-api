function showAlert(container, type) {
  var div = document.createElement("div");

  div.class = "alert alert-" + type + " alert-dismissible";
  div.role = "alert";

  var button = document.createElement("button");
  button.type = "button";
  button.class = "close";
  button.setAttribute("data-dismiss", "alert");

  var closeSpan = document.createElement("span");
  closeSpan.innerHTML = "&times;";

  div.appendChild(button);
  button.appendChild(closeSpan);

  container.appendChild(div);
}

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

    });

    return false;
  });
});
