$(document).on('turbolinks:load', function(){
  $('#question').on('ajax:success', '.question-subscribe-link', function(e) {
    $(this).hide();
  })
})
