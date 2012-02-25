$ ->
  # email - validation
  # disable signup button before ajax call
  $("#member_email").bind('ajax:before', (evt, data, status, xhr) ->
    $("input[type=submit]").attr("disabled", "disabled")
  )
  
  # enable signup button after ajax call
  $("#member_email").bind('ajax:complete', (evt, data, status, xhr) ->
    $("input[type=submit]").removeAttr("disabled")
  )  
  
  # apply css class based on result
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
 
  # disable signup button before ajax call
  $("#member_twitter").bind('ajax:before', (evt, data, status, xhr) ->
    $("input[type=submit]").attr("disabled", "disabled")
  )  
  
  # enable signup button after ajax call
  $("#member_twitter").bind('ajax:complete', (evt, data, status, xhr) ->
    $("input[type=submit]").removeAttr("disabled")
  )  
    
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
  
  # github - validation
 
  # disable signup button before ajax call
  $("#member_github").bind('ajax:before', (evt, data, status, xhr) ->
    $("input[type=submit]").attr("disabled", "disabled")
  )  
  
  # enable signup button after ajax call
  $("#member_github").bind('ajax:complete', (evt, data, status, xhr) ->
    $("input[type=submit]").removeAttr("disabled")
  )  
    
  $("#member_github").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#github_check').html('Invalid github username.')
      $('#member_github').addClass("error")
    else
      $('#member_github').addClass("pass")
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
  )
  
  # blogrss - validation
 
  # disable signup button before ajax call
  $("#member_blogrss").bind('ajax:before', (evt, data, status, xhr) ->
    $("input[type=submit]").attr("disabled", "disabled")
  )  
  
  # enable signup button after ajax call
  $("#member_blogrss").bind('ajax:complete', (evt, data, status, xhr) ->
    $("input[type=submit]").removeAttr("disabled")
  )  
  $("#member_blogrss").bind('ajax:success', (evt, data, status, xhr) ->
    if (data is false) 
      $('#blogrss_check').html('Invalid blog url.')
      $('#member_blogrss').addClass("error")
    else
      $('#member_blogrss').addClass("pass")
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
  )