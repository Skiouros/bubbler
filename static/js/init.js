$(function() {
  $('.photo-list').magnificPopup({
        delegate: ".magnific",
        type: "image",
        gallery: {
            enabled: true
        }
    });
  /********** Owl Carousel **********/
  // Sort random image function
  function random(owlSelector){
    owlSelector.children().sort(function(){
      return Math.round(Math.random()) - 0.5;
    }).each(function() {
      $(this).appendTo(owlSelector);
    });
  }

  // Owl carousel Initialization
  if($(".carousel-lg").length > 0){
    $(".carousel-lg").owlCarousel({
      lazyLoad: true,
      slideSpeed: 300,
      pagination: false,
      paginationSpeed: 400,
      singleItem: true,
      responsive: true,
      responsiveRefreshRate: 200,
      responsiveBaseWidth: window,
      autoheight: true,
      autoPlay: true,
      navigation: true,
      navigationText: [
        "<i class='icon-chevron-left icon-white'></i>",
        "<i class='icon-chevron-right icon-white'></i>"
      ],
      beforeInit: function(elem){
        random(elem);
      },
      stopOnHover: true
    });
  }
  // Owl carousel
    // ================================
    $(".autoplay").owlCarousel({
        lazyLoad: true,
        slideSpeed: 300,
        paginationSpeed: 400,
        singleItem: true,
        autoPlay: true,
        stopOnHover: true,
        navigation: true,
        pagination: false
    });
  /********** End Owl Carousel **********/
  
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


  var substringMatcher = function(strs) {
    return function findMatches(q, cb) {
      var matches, substrRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          // the typeahead jQuery plugin expects suggestions to a
          // JavaScript object, refer to typeahead docs for more info
          matches.push({
            value: str
          });
        }
      });

      cb(matches);
    };
  };
  /********** End Masonry **********/

  /********** Typeahead **********/
  var schools = [
    'University of the Pacific',
    'California State University, Fresno',
    'Stanford',
    'Harvard',
    'University of California Berkely',
    'University of Southern California',
    'California State University, Long Beach',
    'California State University, Sacramento',
    'New Mexico State University',
    'Azuza Pacific University'
  ];
  // Typeahead Initialize
  $('#school-search .typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
  }, {
    name: 'schools',
    displayKey: 'value',
    source: substringMatcher(schools)
  });
  // Constructs the suggestion engine
  var schools = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    local: $.map(schools, function(school) {
      return {
        value: school
      };
    })
  });
  // Starts the loading/processing of `local` and `prefetch`
  schools.initialize();
  // Initialize Bloodhound
  $('#bloodhound .typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
  }, {
    name: 'schools',
    displayKey: 'value',
    // `ttAdapter` wraps the suggestion engine in an adapter that
    // is compatible with the typeahead jQuery plugin
    source: schools.ttAdapter()
  });
  /********** End Typeahead **********/

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

  // autoplay
    $(".auto-play").owlCarousel({
        autoPlay: true
    });
    // ================================
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
});

document.getElementById("schoolsrch").addEventListener("keydown", function(e) {
    if (!e) { var e = window.event; }

    // Enter is pressed
    if (e.keyCode == 13) { window.location.replace("http://beta.bubbler.in/s/uop/housing"); }
}, false);


/*! ========================================================================
 * google.js
 * Page/renders: maps-google.html
 * Plugins used: gmaps
 * ======================================================================== */
$(function () {
    // gmaps - routes
    // ================================
    var styles = [{"stylers":[{"saturation":-100}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#0099dd"}]},{"elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#aadd55"}]},{"featureType":"road.highway","elementType":"labels","stylers":[{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"labels.text","stylers":[{"visibility":"on"}]},{"featureType":"road.local","elementType":"labels.text","stylers":[{"visibility":"on"}]},{}];
    var routes;
    if($('#gmaps-routes').length){
      routes = new GMaps({
          el: "#gmaps-routes",
          lat: 37.974174,
          lng: -121.308358,
          zoomControl : true,
          scrollwheel: false ,
          zoomControlOpt: {
              style : "SMALL",
              position: "TOP_LEFT"
          },
          zoom: 14,
      });
      var isClicked = false;
      routes.setOptions({styles: styles});
      routes.addMarker({
        lat: 37.974174,
        lng: -121.308358,
        title: "Marker with InfoWindow",
        infoWindow: {
        content: '<p>Home</p>'
        }
      });
      routes.addMarker({
        lat: 37.980439,
        lng: -121.310260,
        title: "Marker with InfoWindow",
        infoWindow: {
        content: '<p>Destination</p>'
        }
      });
      routes.travelRoute({
          origin: [37.974174, -121.308358],
          destination: [37.980439, -121.310260],
          travelMode: "driving",
          step: function(e){
              $("#gmaps-routes-inst").append('<li>'+e.instructions+'</li>');
              $("#gmaps-routes-inst li:eq("+e.step_number+")").delay(450*e.step_number).fadeIn(200, function(){
                  routes.drawPolyline({
                      path: e.path,
                      strokeColor: "#00a2f9",
                      strokeOpacity: 0.6,
                      strokeWeight: 6
                  });  
              });
          }
      });
    }
    // select date range
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
});