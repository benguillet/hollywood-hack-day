//= require jquery

$(document).ready(function() {
    var url = $('#url').text();

    $('#add_list').click(function() {
        var loading_add_list = $('#loading_add_list');
        loading_add_list.show();
        $.ajax({
          type: "POST",
          url: "/share-to/me",  
          data: {'url': url},
          success: function() {
            loading_add_list.hide();
            $('#notification').text('succes').removeClass('alert-error').addClass("alert-success").show();
          },
          error: function() {
            loading_add_list.hide();
            $('#notification').text('fail').removeClass('alert-success').addClass("alert-error").show();
          }
        });
    });

    $('#share_friends').click(function() {
        var url = $('#url').text();
        var loading_share_friends = $('#loading_share_friends');
        loading_share_friends.show();
        $.ajax({
          type: "POST",
          url: "/share-to/friends",  
          data: {'url': url},
          success: function() {
            loading_share_friends.hide();
            $('#notification').text('succes').removeClass('alert-error').addClass("alert-success").show();
          },
          error: function() {
            loading_share_friends.hide();
            $('#notification').text('fail').removeClass('alert-success').addClass("alert-error").show();
            
          }
        });  
    });
});