$(document).on('turbolinks:load', function(){
  $('.question').on('click', '#question-edit', function(e) {
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show();
  })
});
