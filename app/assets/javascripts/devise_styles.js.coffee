$ ->
  # email - validation
  # apply css class based on result
  $("#member_email").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#email_check').html('Email format is invalid.')
      $('#member_email').addClass("error")
      setImageClass("#email_status", "invalid")
    else
      $('#member_email').addClass("pass")
      setImageClass("#email_status", "valid")
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
    setImageClass("#email_status", "new")
  )

  $("#member_email").bind('ajax:beforeSend', ->
    setImageClass("#email_status", "checking")
  )

  # twitter - validation
  $("#member_twitter").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#twitter_check').html('Invalid twitter username.')
      $('#member_twitter').addClass("error")
      setImageClass("#twitter_status", "invalid")
    else
      $('#member_twitter').addClass("pass")
      setImageClass("#twitter_status", "valid")
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
    setImageClass("#twitter_status", "new")
  )

  $("#member_twitter").bind('ajax:beforeSend', ->
    setImageClass("#twitter_status", "checking")
  )

  # github - validation
  $("#member_github").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#github_check').html('Invalid github username.')
      $('#member_github').addClass("error")
      setImageClass("#github_status", "invalid")
    else
      $('#member_github').addClass("pass")
      setImageClass("#github_status", "valid")
  )

  # github - cancel ajax call if input field empty
  $("#member_github").live('ajax:before', ->
    if $(@).val() is ''
      false
  )

  $("#member_github").focus( ->
    $('#github_check').empty()
    $('#member_github').removeClass("error")
    $('#member_github').removeClass("pass")
    setImageClass("#github_status", "new")
  )

  $("#member_github").bind('ajax:beforeSend', ->
    setImageClass("#github_status", "checking")
  )

  # blogrss - validation
  $("#member_blogrss").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#blogrss_check').html('Invalid blog url.')
      $('#member_blogrss').addClass("error")
      setImageClass("#blogrss_status", "invalid")
    else
      $('#member_blogrss').addClass("pass")
      setImageClass("#blogrss_status", "valid")
  )

  # blogrss - cancel ajax call if input field empty
  $("#member_blogrss").live('ajax:before', ->
    if $(@).val() is ''
      false
  )

  $("#member_blogrss").focus( ->
    $('#blogrss_check').empty()
    $('#member_blogrss').removeClass("error")
    $('#member_blogrss').removeClass("pass")
    setImageClass("#blogrss_status", "new")
  )

  $("#member_blogrss").bind('ajax:beforeSend', ->
    setImageClass("#blogrss_status", "checking")
  )


  setImageClass = (elementId, newClass) ->
    $(elementId).removeClass("new valid invalid checking")
    $(elementId).addClass(newClass)
