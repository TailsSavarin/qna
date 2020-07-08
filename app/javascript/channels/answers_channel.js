import consumer from "./consumer"

$(document).on('turbolinks:load', function(){

  var questionId = $('#question').attr('data-question-id') 

  consumer.subscriptions.create({ channel: "AnswersChannel",
    question_id: questionId }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to the question ' + questionId)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data)
      $('.answers').append(`<div id="answer-${data.id}"><div class="card border-secondary rounded mb-3 mt-4"></p><p>${data.body}</p></div></div>`)
    }
  });
})
