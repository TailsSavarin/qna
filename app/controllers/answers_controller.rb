class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy update choose_best vote_up vote_down revote]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def choose_best
    @answer.select_best if current_user.author_of?(@answer.question)
  end

  def vote_up
    @answer.create_vote_up(current_user.id)
    render json: { id: @answer.id, rating: @answer.rating }
  end

  def vote_down
    @answer.create_vote_down(current_user.id)
    render json: { id: @answer.id, rating: @answer.rating }
  end

  def revote
    @answer.make_revote(current_user.id)
    render json: { id: @answer.id, rating: @answer.rating }
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[id name url _destroy])
  end
end
