$ ->
  # email - validation
  $("#member_email").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#email_check').html('Email format is invalid.')
      $('#member_email').addClass("error")
    else
      $('#member_email').addClass("pass")
  )

  # email - cancel ajax call if input field empty
  $("#member_email").live('ajax:before', ->
    if $(@).val() is ''
      false
  )
  $("#member_email").focus( ->
    $('#email_check').empty()
    $('#member_email').removeClass("error")
    $('#member_email').removeClass("pass")
  )
  
 # twitter - validation
  $("#member_twitter").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#twitter_check').html('Invalid twitter username.')
      $('#member_twitter').addClass("error")
    else
      $('#member_twitter').addClass("pass")
  )

  # twitter - cancel ajax call if input field empty
  $("#member_twitter").live('ajax:before', ->
    if $(@).val() is ''
      false
  )
  $("#member_twitter").focus( ->
    $('#twitter_check').empty()
    $('#member_twitter').removeClass("error")
    $('#member_twitter').removeClass("pass")
  )
  
