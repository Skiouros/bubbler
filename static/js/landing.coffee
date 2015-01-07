$(document).ready ->
    if $('.testimonials-slider').length > 0
        $('.testimonials-slider').flexslider
            manualControls: '.flex-manual .switch'
            nextText: ""
            prevText: ""
            startAt: 1
            slideshow: false
            direction: "horizontal"
            animation: "slide"

    fixmenu = new Headhesive ".navigation-header",
        offset: "#showHere"
        classes:
            clone: "fixmenu-clone"
            stick: "fixmenu-stick"
            unstick: "fixmenu-unstick"

    $('.navigation-bar').onePageNav
        currentClass: "active"
        changeHash: true
        scrollSpeed: 750
        scrollThreshold: 0.5
        easing: "swing"

    # animation shit
    if $(window).width() > 1024
        $(".animated").appear(->
            element = $(this)
            animation = element.data "animation"
            delay = element.data "delay"

            setTimeout ->
                element.addClass "#{animation} visible"
                element.removeClass "hiding"
            , delay or 1
        , accY: -150)
    else
        $('.animated').css "opacity", 1

    $('.scroll-top').click ->
        $("html, body").animate
            scrollTop: 0
            easing: "swing"
        , 750

    toastr.options = positionClass: "toast-top-full-width"

    form = $ ".form-register"
    form.submit (e) ->
        $.ajax
            type: form.attr "method"
            url: form.attr "action"
            data: form.serialize()
            success: (data) ->
                console.log data
                # clear errors
                for name in ["fullname", "college", "email", "password"]
                    $("##{name}-error").remove()

                if data.msg
                    toastr.success data.msg
                else
                    for err in data.errors
                        array = err.split " "
                        id = array.shift()

                        $("##{id}").after "
                            <label id='#{id}-error' class='error'>#{array.join " "}</label>
                        "

        e.preventDefault()
