class Answer < ApplicationRecord
  include Votable
  include Linkable
  include Attachable
  include Authorable
  include Commentable

  default_scope { order('best desc, created_at') }

  belongs_to :question, touch: true

  validates :body, presence: true

  after_commit :send_notice, on: :create

  def select_best
    Answer.transaction do
      Answer.where(question_id: question_id).update_all(best: false) # rubocop:disable Rails/SkipsModelValidations
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end

  private

  def send_notice
    NewAnswerNoticeJob.perform_later(self)
  end
end
