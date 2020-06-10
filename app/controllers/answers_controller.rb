class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    answer_author = { user_id: current_user.id }
    @answer = @question.answers.new(answer_params.merge(answer_author))

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to @answer.question, notice: "You don't have sufficient rights to delete this answer."
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
