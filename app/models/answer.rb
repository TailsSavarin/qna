class Answer < ApplicationRecord
  default_scope { order('best desc, created_at') }

  belongs_to :user
  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def select_best
    Answer.transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      update!(best: true)
    end
  end
end
