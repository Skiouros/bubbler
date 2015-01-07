/*! ========================================================================
 * google.js
 * Page/renders: maps-google.html
 * Plugins used: gmaps
 * ======================================================================== */
$(function () {
    // gmaps - routes
    // ================================
    var routes = new GMaps({
        el: "#gmaps-routes",
        lat: 37.974174,
        lng: -121.308358,
    });
    var pinColor = "00a2f9";
    var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
        new google.maps.Size(21, 34),
        new google.maps.Point(0,0),
        new google.maps.Point(10, 34));
    var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
        new google.maps.Size(40, 37),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 35));

    routes.addMarker({
        lat: 37.974174,
        lng: -121.308358,
                icon: pinImage,
                shadow: pinShadow  });

    var isClicked = false;

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
});