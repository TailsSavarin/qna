class Question < ApplicationRecord
  belongs_to :author, inverse_of: :authored_questions, class_name: 'User', foreign_key: 'user_id'
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
