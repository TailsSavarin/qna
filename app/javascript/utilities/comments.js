$(document).on('turbolinks:load', function(){
  $('.comments-btn').on('click', '.add-comment', function(e) {
    e.preventDefault();
    $(this).hide();
    $('form.new-comment').show();
  })
})



