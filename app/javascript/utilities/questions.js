$(document).on('turbolinks:load', function(){
  $('.question').on('click', '#question-edit', function(e) {
    e.preventDefault();
    $(this).hide();
    $(`form#edit-question`).show();
  })

  $('.question').on('ajax:success', '.voting-buttons', function(e) {
    var question = e.detail[0];
    $(`.question .voting-buttons`).hide();
    $(`.question .revote`).show();
    $(`.question .rating`).html(question.rating);
  })

  $('.question').on('ajax:success', '.revote', function(e) {
    var question = e.detail[0];
    $(`.question .voting-buttons`).show();
    $(`.question .revote`).hide();
    $(`.question .rating`).html(question.rating);
  })
});
