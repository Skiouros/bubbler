$ ->
    $("p.timeago").timeago()
	if $(".masonry").length > 0
	    $(".masonry").masonry
	      itemSelector: ".post"
	      columnWidth: ".post"

  $(window).load ->
    $(".masonry").masonry "layout"
    return
