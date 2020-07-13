class AnswersChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:question_id].blank?
    stream_from "question_#{params[:question_id]}"
  end
end
