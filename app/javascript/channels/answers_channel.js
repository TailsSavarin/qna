import consumer from "./consumer"

  consumer.subscriptions.create({ channel: "AnswersChannel",
    question_id: 1 }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to the question')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data)
    }
  });
