class Answer < ApplicationRecord
  default_scope { order('best desc, created_at') }

  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def select_best
    Answer.transaction do
      Answer.where(question_id: question_id).find_each { |answer| answer.update(best: false) }
      update!(best: true)
    end
  end
end
