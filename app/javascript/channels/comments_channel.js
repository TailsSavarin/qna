import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  var questionId = $('#question').attr('data-question-id')
  consumer.subscriptions.create({ channel: "CommentsChannel",
    question_id: questionId }, {
    connected() {
      console.log('Connected to the question ' + questionId)
    },

    disconnected() {
    },

    received(data) {
      console.log(data)
      var commentableType = data.commentable_type.toLowerCase();
      var commentableId = data.commetable_id

      if (gon.user_id != data.user_id) {
        $(`#${commentableType}-${data.commentable_id}-comments`).append(`<div class="card border-light"><div class="card-body">${data.body}</div></div>`)
      }
    }
  });
});
