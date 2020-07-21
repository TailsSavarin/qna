$(document).on('turbolinks:load', function(){
  $('#question').on('click', '#question-edit-link', function(e) {
    e.preventDefault();
    $(this).hide();
    $(`#edit-question`).show();
  })

  $('#question').on('ajax:success', '.question-voting-buttons-links', function(e) {
    var question = e.detail[0];
    $(`#question .question-voting-buttons-links`).hide();
    $(`#question .question-revote-link`).show();
    $(`#question .question-rating`).html('Rating: ' + question.rating);
  })

  $('#question').on('ajax:success', '.question-revote-link', function(e) {
    var question = e.detail[0];
    $(`#question .question-voting-buttons-links`).show();
    $(`#question .question-revote-link`).hide();
    $(`#question .question-rating`).html('Rating: ' + question.rating);
  })

  .on('ajax:error', function(e) {
    window.location = 'http://localhost:3000/403'
  })
});
