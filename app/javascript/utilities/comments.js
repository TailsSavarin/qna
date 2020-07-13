$(document).on('turbolinks:load', function(){
  $('#question').on('click', '.add-comment', function(e) {
    e.preventDefault();

    var commentableId = $(this).data('commentableId');
    var commentableClass = $(this).data('commentableClass');

    $(this).hide();
    $(`form#new-comment-${commentableClass}-${commentableId}`).show();
  })
})



