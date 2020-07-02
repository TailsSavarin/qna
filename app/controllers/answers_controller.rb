class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy update choose_best vote_up vote_down]

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
    @answer.votes.find_or_create_by(user_id: current_user.id) { |c| c.vote_count = 1 }

    render json: { id: @answer.id, votes_counter: @answer.votes_counter }
  end

  def vote_down
    @answer.votes.find_or_create_by(user_id: current_user.id) { |c| c.vote_count = -1 }

    render json: { id: @answer.id, votes_counter: @answer.votes_counter }
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
