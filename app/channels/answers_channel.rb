class AnswersChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "question_#{data['question_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
