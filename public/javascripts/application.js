// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  // show/hide login/signup boxes
  $(".login-nav li a").click(function() {
    // hide both login and signup boxes
    $("#login-box").hide();
    $("#signup-box").hide();
    
    var title = $(this).attr('title');
    
    // show the box that needs to be shown
    $("#" + title + "-box").show();
    
    // move the current caret (if it needs to be moved)
    if (title == 'login') { $(".login-nav img").animate({left: '77px'}, 200); };
    if (title == 'signup') { $(".login-nav img").animate({left: '277px'}, 200); }
    
    return false;
  });
  
  // create qtip for google username help
  $('.google_username_help').qtip({
    content: "Can't remember your username?\n<a href='https://www.google.com/accounts/ForgotPasswd?service=mail&fuOnly=1' target='_blank'>Recover from Google<a/>",
    hide: {when: 'unfocus'},
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
  
  // create qtip for "What is this?"
  $('#what').qtip({
    content: "SelectiveBuzz allows you to push content from your Google Buzz account to Twitter and Facebook by using special tags.",
    show: {
      when: 'click'
    },
    hide: {
      when: 'unfocus'
    },
    position: {
      corner: {
        target: 'bottomMiddle',
        tooltip: 'topMiddle'
      }
    },
    style: {
      name: 'light',
      tip: 'topMiddle',
      width: {
        max: 300
      },
      border: {
        width: 5,
        radius: 6
      }
    }
  });
  
  // create qtip for "How does this work?"
  $('#how').qtip({
    content: "It's easy! After you sign up, you can enable Twitter and Facebook integration for your account. If you post content to your Google Buzz account with special tags (#fb for Facebook and #tweet for Twitter) SelectiveBuzz will push that content to your respective accounts.",
    show: {
      when: 'click'
    },
    hide: {
      when: 'unfocus'
    },
    position: {
      corner: {
        target: 'bottomMiddle',
        tooltip: 'topMiddle'
      }
    },
    style: {
      name: 'light',
      tip: 'topMiddle',
      width: {
        max: 350
      },
      border: {
        width: 5,
        radius: 6
      }
    }
  });
});

