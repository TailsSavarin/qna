$(document).on('turbolinks:load', function(){
  $('#question').on('click', '.add-comment-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var commentableId = $(this).data('commentableId');
    var commentableType = $(this).data('commentableType');
    $(`#new-comment-${commentableType}-${commentableId}`).show();
  })

  .on('ajax:error', function(e) {
    window.location = 'http://localhost:3000/403'
  })
})



