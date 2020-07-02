class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy vote_up vote_down revote]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
    @question.votes.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to questions_path, notice: "You don't have sufficient rights to delete this question."
    end
  end

  def vote_up
    @question.create_vote_up(current_user.id)
    render json: { id: @question.id, rating: @question.rating }
  end

  def vote_down
    @question.create_vote_down(current_user.id)
    render json: { id: @question.id, rating: @question.rating }
  end

  def revote
    @question.make_revote(current_user.id)
    render json: { id: @question.id, rating: @question.rating }
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id title image _destroy])
  end
end
