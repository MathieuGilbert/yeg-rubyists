$ ->
  # username - validation
  $("#member_email").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#email_check').html('Email format is invalid.')
      $('#member_email').addClass("error")
    else
      $('#member_email').addClass("pass")
  )

  # username - cancel ajax call if input field empty
  $("#member_email").live('ajax:before', ->
    if $(@).val() is ''
      false
  )
  $("#member_email").focus( ->
    $('#email_check').empty()
    $('#member_email').removeClass("error")
    $('#member_email').removeClass("pass")
  )
  
