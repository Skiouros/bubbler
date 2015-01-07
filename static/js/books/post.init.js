    $('.book-image-list').magnificPopup({
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
  // ================================
   if($(".auto-play").length > 0) {
    $(".auto-play").owlCarousel({
        autoPlay: true
    });
  }