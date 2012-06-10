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
});