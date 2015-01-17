$ ->
    form = $ "#form"
    form.submit (e) ->
        $.ajax
            url: form.attr "action"
            type: form.attr "method"
            data: form.serialize()
            success: (data) ->
                $("#error-container").empty()

                if data.redirect_to
                    window.location.href = data.redirect_to
                else if data.errors
                    for err in data.errors
                        $("#error-container").append "
                        <p>#{err}</li>
                        "
        console.log form.serialize()
        e.preventDefault()
