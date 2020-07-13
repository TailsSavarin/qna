$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $(`#edit-answer-${answerId}`).show();
  })

  $('.answers').on('ajax:success', '.answer-voting-buttons-links', function(e) {
    var answer = e.detail[0];
    $(`#answer-${answer.id} .answer-voting-buttons-links`).hide();
    $(`#answer-${answer.id} .answer-revote-link`).show();
    $(`#answer-${answer.id} .answer-rating`).html('Rating: ' + answer.rating);
  })

  $('.answers').on('ajax:success', '.answer-revote-link', function(e) {
    var answer = e.detail[0];
    $(`#answer-${answer.id} .answer-voting-buttons-links`).show();
    $(`#answer-${answer.id} .answer-revote-link`).hide();
    $(`#answer-${answer.id} .answer-rating`).html('Rating: ' + answer.rating);
  })
});
