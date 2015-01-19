$ ->
    $("p.timeago").timeago()
	if $(".masonry-books").length > 0
	    $(".masonry").masonry
	      itemSelector: ".post"
	      columnWidth: ".post"
    else $(".masonry").masonry itemSelector: ".post" columnWidth: ".post"  if $(".masonry-housing").length > 0

    $(window).load ->
        $(".masonry").masonry "layout"
        return
