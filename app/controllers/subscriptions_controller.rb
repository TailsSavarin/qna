class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])

    @subscription = @question.subscriptions.find_or_initialize_by(user: current_user)
    @subscription.save

    if @subscription.save
      head :created
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
