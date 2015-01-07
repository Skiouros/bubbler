/********** Search page filters **********/
  // Logic to Hide and Open Filter options
  var clicked = false;
  $('#open_filters').click(function() {
    if (!clicked) {
      $('#open_filters').removeClass('btn-danger').addClass('btn-primary').html("Close Filters");
      clicked = true;
    }
  });
  $('#filter_books_modal').on('hidden.bs.modal', function (){
    if (clicked){
      $('#open_filters').removeClass('btn-primary').addClass('btn-danger').html("Filters");
      clicked = false;
    }
  });
  $('#filter_housing_modal').on('hidden.bs.modal', function (){
    if (clicked){
      $('#open_filters').removeClass('btn-primary').addClass('btn-danger').html("Filters");
      clicked = false;
    }
  });
  /********** End Search page filters **********/

  /********** Masonry **********/
  // Masonry Initialization
  if($(".masonry").length > 0){
    $(".masonry").masonry({
      itemSelector: ".post",
      columnWidth: ".post"
    });
    // Relocate panel on window ready
    $(window).load(function(){
      $(".masonry").masonry("layout");
    });
  }
  // select date range
if($("#datepicker-from") && $("#datepicker-to")){
    $("#datepicker-from").datepicker({
        defaultDate: "+1w",
        numberOfMonths: 2,
        onClose: function (selectedDate) {
            $("#datepicker-to").datepicker("option", "minDate", selectedDate);
        }
    });
     $("#datepicker-to").datepicker({
        defaultDate: "+1w",
        numberOfMonths: 2,
        onClose: function (selectedDate) {
            $("#datepicker-from").datepicker("option", "maxDate", selectedDate);
        }
    });
   }

   // ================================
  if($("#selectize-tagging")){
     $("#selectize-tagging").selectize({
        delimiter: ",",
        persist: false,
        create: function (input) {
            return {
                value: input,
                text: input
            }
        }
    });
   }