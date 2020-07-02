$(document).on('turbolinks:load', function(){
  $('.question').on('click', '#question-edit', function(e) {
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show();
  })

  $('.question').on('ajax:success', '.vote-up, .vote-down', function(e) {
    var question = e.detail[0];
    
    $('.question .vote-up').hide();
    $('.question .vote-down').hide();
    $('.question .rating').html(question.votes_counter);
  })
});
