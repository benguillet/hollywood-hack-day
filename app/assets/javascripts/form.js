//= require jquery

$(document).ready(function() {
    var url = $('#url').text();

    $('#add_list').click(function() {
        console.log(url);
        $.ajax({
          type: "POST",
          url: "/share-to/me",  
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
          url: "/share-to/friends",  
          data: {'url': url},
          success: function() {  
           
          }  
        });  
    });
});