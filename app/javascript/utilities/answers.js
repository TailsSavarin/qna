$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.answer-edit', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  $('.answers').on('ajax:success', '.voting-buttons', function(e) {
    var answer = e.detail[0];
    
    $(`#answer-${answer.id} .voting-buttons`).hide();
    $(`#answer-${answer.id} .revote`).show();
    $(`#answer-${answer.id} .rating`).html(answer.rating);
  })

  $('.answers').on('ajax:success', '.revote', function(e) {
    var answer = e.detail[0];
    
    $(`#answer-${answer.id} .voting-buttons`).show();
    $(`#answer-${answer.id} .revote`).hide();
    $(`#answer-${answer.id} .rating`).html(answer.rating);
  })
});
