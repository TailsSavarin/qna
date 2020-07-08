class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{data['question_id']}"
  end
end
