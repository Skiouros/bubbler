$ ->
  random = (owlSelector) ->
    owlSelector.children().sort(->
      Math.round(Math.random()) - 0.5
    ).each ->
      $(this).appendTo owlSelector
      return
    return

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
        return
      stopOnHover: true

  $(".auto-play").owlCarousel autoPlay: true  if $(".auto-play").length > 0

  styles = [
    {
      stylers: [saturation: -100]
    }
    {
      featureType: "water"
      elementType: "geometry.fill"
      stylers: [color: "#0099dd"]
    }
    {
      elementType: "labels"
      stylers: [visibility: "off"]
    }
    {
      featureType: "poi.park"
      elementType: "geometry.fill"
      stylers: [color: "#aadd55"]
    }
    {
      featureType: "road.highway"
      elementType: "labels"
      stylers: [visibility: "on"]
    }
    {
      featureType: "road.arterial"
      elementType: "labels.text"
      stylers: [visibility: "on"]
    }
    {
      featureType: "road.local"
      elementType: "labels.text"
      stylers: [visibility: "on"]
    }
  ]
  routes = undefined
  if $("#gmaps-routes").length
    routes = new GMaps(
      el: "#gmaps-routes"
      lat: 37.974174
      lng: -121.308358
      zoomControl: true
      scrollwheel: false
      zoomControlOpt:
        style: "SMALL"
        position: "TOP_LEFT"

      zoom: 14
    )
    isClicked = false
    routes.setOptions styles: styles
    routes.addMarker
      lat: 37.974174
      lng: -121.308358
      title: "Marker with InfoWindow"
      infoWindow:
        content: "<p>Home</p>"

    routes.addMarker
      lat: 37.980439
      lng: -121.310260
      title: "Marker with InfoWindow"
      infoWindow:
        content: "<p>Destination</p>"

    routes.travelRoute
      origin: [
        37.974174
        -121.308358
      ]
      destination: [
        37.980439
        -121.310260
      ]
      travelMode: "driving"
      step: (e) ->
        $("#gmaps-routes-inst").append "<li>" + e.instructions + "</li>"
        $("#gmaps-routes-inst li:eq(" + e.step_number + ")").delay(450 * e.step_number).fadeIn 200, ->
          routes.drawPolyline
            path: e.path
            strokeColor: "#00a2f9"
            strokeOpacity: 0.6
            strokeWeight: 6
          return
        return