$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.answer-edit', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })
});
