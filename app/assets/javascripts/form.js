//= require jquery
$(document).ready(function() {
    $('#add_list').click(function() {
        var url = $('#url').text();
        console.log(url);
        $.ajax({
          type: "POST",
          url: "http://localhost.com:3000/share-to/me",  
          data: {'url': url},
          success: function() {  
           
          }  
        });  
    });

    $('#share_friends').click(function() {
        var url = $('#url').text();
        console.log(url);
        $.ajax({
          type: "POST",
          url: "http://localhost:3000/share-to/friends",  
          data: {'url': url},
          success: function() {  
           
          },
          error: function(data) {
            
          }
        });  
    });

    $('#post_fb').click(function() {
        var publish = {
            method: 'stream.publish',
            message: 'has shared a link via moShare !',
            picture : img,
            link : currentShare,
            name: title,
            caption: '',
            description: senderMess,
            actions : { name : 'moShare it again!', link : newLink}
        };

             FB.api('/me/feed', 'POST', publish, function(response) {  
                 if (!response || response.error) {
                    console.log(response.error.message);
                    $('#facebook_status_message').html('<p>Impossible to share with Facebook! An error occurred</p>').fadeIn('slow').removeClass('success').addClass('error');
                  } else {
                    $('#facebook_status_message').html('<p>Shared with Facebook!</p>').fadeIn('slow').removeClass('error').addClass('success');
                  }
             });
    
    });
});