$ ->
  # TODO: Clean up this filter button logic 
  clicked = false
  $("#open_filters").click ->
    unless clicked
      $("#open_filters").removeClass("btn-danger").addClass("btn-primary").html "Close Filters"
      clicked = true
    return

  $("#filter_books_modal").on "hidden.bs.modal", ->
    if clicked
      $("#open_filters").removeClass("btn-primary").addClass("btn-danger").html "Filters"
      clicked = false
    return

  $("#filter_housing_modal").on "hidden.bs.modal", ->
    if clicked
      $("#open_filters").removeClass("btn-primary").addClass("btn-danger").html "Filters"
      clicked = false
    return

  if $(".masonry").length > 0
    $(".masonry").masonry
      itemSelector: ".post"
      columnWidth: ".post"
    
  $(window).load ->
    $(".masonry").masonry "layout"
    return

  if $("#datepicker-from") and $("#datepicker-to")
    $("#datepicker-from").datepicker
      defaultDate: "+1w"
      numberOfMonths: 2
      onClose: (selectedDate) ->
        $("#datepicker-to").datepicker "option", "minDate", selectedDate
        return

  $("#datepicker-to").datepicker
    defaultDate: "+1w"
    numberOfMonths: 2
    onClose: (selectedDate) ->
      $("#datepicker-from").datepicker "option", "maxDate", selectedDate
      return

  if $("#selectize-tagging")
    $("#selectize-tagging").selectize
      delimiter: ","
      persist: false
      create: (input) ->
        value: input
        text: input
