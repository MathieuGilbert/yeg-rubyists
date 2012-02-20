$ ->
  $("#member_name").bind('ajax:success', (evt, data, status, xhr) ->
    if (data isnt null) 
      $('#username_check').html(data.name + ' is already taken')
    else
      $('#username_check').html('Username is available!')
  )

  #cancel Ajax call if input field empty
  $("#member_name").live('ajax:before', ->
    if $(@).val() is ''
      false
  )

  $("#member_name").focus( ->
    $('#username_check').empty()
  )