$ ->
    $("p.timeago").timeago()
    if $(".masonry-books").length > 0 and not $("#no_books")
        $(".masonry-books").masonry
          itemSelector: ".post"
          columnWidth: ".post"
    else if $(".masonry-housing").length > 0 and not $("#no_houses")
        $(".masonry-housing").masonry 
            itemSelector: ".post" 
            columnWidth: ".post"  

    $(window).load ->
        $(".masonry").masonry "layout"
        return