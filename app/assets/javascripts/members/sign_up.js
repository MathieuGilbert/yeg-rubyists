$(document).ready(function() {
  $("#member_name").bind('ajax:success', function(evt, data, status, xhr){
    if (data !== null) {
      $('#username_check').html(data.name + ' is already taken');
    } else {
      $('#username_check').html('Username is available!');
    }
  });
  
  // cancel Ajax call if input field empty
  $("#member_name").live('ajax:before', function(){
    if ($(this).val() == '') {
      return false;
    }
  });

  $("#member_name").focus(function(){
    $('#username_check').empty();
  });
  
});