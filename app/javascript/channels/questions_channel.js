import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Connected to the question list')
    },

    disconnected() {
    },

    received(data) {
      $('.questions-list').append(`<div class="card mb-2"><div class="card-body"><h4><a href="/questions/${data.id}">${data.title}</a></h1>${data.body}</div></div>`)
    }
  })
});
