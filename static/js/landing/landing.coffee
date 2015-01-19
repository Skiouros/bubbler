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

    form_register = $ ".form-register"
    form_register.submit (e) ->
        $.ajax
            type: form_register.attr "method"
            url: form_register.attr "action"
            data: form_register.serialize()
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

    form_feedback = $ ".feedback-form"
    form_feedback.submit (e) ->
        $.ajax
            type: form_feedback.attr "method"
            url: form_feedback.attr "action"
            data: form_feedback.serialize()
            success: (data) ->
                console.log data
                console.log form_feedback.serializeArray()
                $("#feedback-errors").empty()
                if data.msg == "ok"
                    $("feedback_form").modal("toggle")
                else if data.errors
                    console.log "errors!"
                    for err in data.errors
                        $("#feedback-errors").append "<p>#{err}</p>"
        e.preventDefault()
