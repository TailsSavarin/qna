import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var questionId = $('#question').attr('data-question-id') 
  consumer.subscriptions.create({ channel: "AnswersChannel",
    question_id: questionId }, {
    connected() {
      console.log('Connected to the question ' + questionId)
    },

    disconnected() {
    },

    received(data) {
      if (gon.user_id != data.user_id) {
        $('.answers').append(`<div class="card border-secondary rounded mb-3 mt-4"><div class="card-body"><p>${data.body}</p></div></div>`)
      }
    }
  });
});
