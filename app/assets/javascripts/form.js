//= require jquery

$(document).ready(function() {
    var url = $('#url').text();

    $('#add_list').click(function() {
        $.ajax({
          type: "POST",
          url: "/share-to/me",  
          data: {'url': url},
          success: function() {
            $('#notification').show();
          },
          error: function() {

          }
        });
    });

    $('#share_friends').click(function() {
        var url = $('#url').text();
        $.ajax({
          type: "POST",
          url: "/share-to/friends",  
          data: {'url': url},
          success: function() {  
           $('#notification').show();
          },
          error: function() {
            
          }
        });  
    });
});