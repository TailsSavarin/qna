class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[update]
  before_action :set_question, only: %i[index create]

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.with_attached_files.find(params[:id])
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
