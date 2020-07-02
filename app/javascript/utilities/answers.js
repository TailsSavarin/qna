$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.answer-edit', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  $('.answers').on('ajax:success', '.vote-up, .vote-down', function(e) {
    var answer = e.detail[0];
    
    $(`#answer-${answer.id} .vote-up`).hide();
    $(`#answer-${answer.id} .vote-down`).hide();
    $(`#answer-${answer.id} .rating`).html(answer.votes_counter);
  })
});
