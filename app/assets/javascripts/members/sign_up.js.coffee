$ ->
  # username - validation
  $("#member_name").bind('ajax:success', (evt, data, status, xhr) ->
    if (data isnt null) 
      $('#username_check').html('Username is already taken')
      $('#member_name').addClass("error")
    else
      $('#member_name').addClass("pass")
  )

  # username - cancel ajax call if input field empty
  $("#member_name").live('ajax:before', ->
    if $(@).val() is ''
      false
  )
  $("#member_name").focus( ->
    $('#username_check').empty()
    $('#member_name').removeClass("error")
    $('#member_name').removeClass("pass")
  )
  
