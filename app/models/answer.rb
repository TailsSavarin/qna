class Answer < ApplicationRecord
  include Votable
  include Linkable
  include Attachable
  include Authorable

  default_scope { order('best desc, created_at') }

  belongs_to :question

  validates :body, presence: true

  def select_best
    Answer.transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
