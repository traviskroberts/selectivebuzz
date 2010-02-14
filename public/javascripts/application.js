// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  // apply uniform styles to form elements
  $("select, :checkbox, :radio, :file, :text, :password").uniform();
  
  // create qtip for google username help
  $('.google_username_help').qtip({
    content: "Can't remember your username?\n<a href='https://www.google.com/accounts/ForgotPasswd?service=mail&fuOnly=1' target='_blank'>Recover from Google<a/>",
    hide: 'unfocus',
    position: {
      corner: {
        target: 'topRight',
        tooltip: 'bottomLeft'
      }
    },
    style: {
      name: 'light',
      tip: 'bottomLeft'
    }
  })
});

