$(document).ready ->
    form = $ "#form-login"
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
                        <ul class='parsley-errors-list filled' id='parsley-id-6054'>
                            <li class='parsley-custom-error-message'>#{err}</li>
                        </ul>
                        "

        e.preventDefault()
