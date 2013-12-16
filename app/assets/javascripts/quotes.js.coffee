$(document).ready ()->
  $("#location-toggle-button").toggleButtons
    width: 280
    label:
      enabled: "regional"
      disabled: "all-of-Switzerland"
    onChange: ($el, status, e) ->
      $("select#region").toggle(500);
      if status
        $("#project_region_id").val($("#region").val());
      else
        $("#project_region_id").val("");
      if ($("#location-toggle-button > div > label").text()) is "regional"
        $("#location-toggle-button > div > label").text("all-of-Switzerland")
      else
        $("#location-toggle-button > div > label").text("regional")
  $("#location-toggle-button > div > label").text("regional")

  $("select#region").change ()->
    if $("#location-toggle-button input[type='checkbox']").is(":checked")
      $("#project_region_id").val($("#region").val());

  $.validator.addMethod "end_date_before_start", ((value, element) ->
    (new Date($("#project_start_date").val()) - new Date($("#project_end_date").val())) < 0
    ), ""

  $.validator.addMethod "start_date_lower_now", ((value, element) ->
    myDate = value
    today = new Date()
    dd = today.getDate()
    mm = today.getMonth() + 1
    dd = "0" + dd  if dd < 10
    mm = "0" + mm  if mm < 10
    today = today.getFullYear() + "-" + mm + "-" + dd
    Date.parse(myDate) >= Date.parse(today)
  ), ""

  $('#quote_details_form').validate
    rules:
      "project[description]": {required: true}
      "project[start_date]": {required: true, start_date_lower_now: true}
      "project[end_date]": {required: true, end_date_before_start: true}
      "project[budget]": {required: true, digits:true}
    messages:
      "project[end_date]" : {end_date_before_start : "Enddatum ist kleiner als das Startdatum"}
      "project[start_date]" : {start_date_lower_now : "Startdatum ist weniger als heute"}


