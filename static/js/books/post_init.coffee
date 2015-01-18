$ ->
    $(".book-image-list").magnificPopup
        delegate: ".magnific"
        type: "image"
        gallery:
            enabled: true

    random = (owlSelector) ->
        owlSelector.children().sort(->
            Math.round(Math.random()) - 0.5
        ).each ->
            $(this).appendTo owlSelector

  if $(".carousel-lg").length > 0
      $(".carousel-lg").owlCarousel
        lazyLoad: true
        slideSpeed: 300
        pagination: false
        paginationSpeed: 400
        singleItem: true
        responsive: true
        responsiveRefreshRate: 200
        responsiveBaseWidth: window
        autoheight: true
        autoPlay: true
        navigation: true
        navigationText: [
          "<i class='icon-chevron-left icon-white'></i>"
          "<i class='icon-chevron-right icon-white'></i>"
        ]
        beforeInit: (elem) ->
          random elem
        stopOnHover: true

    $(".auto-play").owlCarousel autoPlay: true  if $(".auto-play").length > 0

    # Change UTC to New Date Format
    if $("#post_date")
        dateTime = $("#post_date").text()
        date = new Date(dateTime)
        year = date.getFullYear()
        month = parseInt(date.getMonth()) + 1
        day = date.getDate()
        $("#post_date").text month + "/" + day + "/" + year
