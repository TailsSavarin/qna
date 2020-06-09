class User < ApplicationRecord
  has_many :authored_questions, inverse_of: :author, class_name: 'Question', foreign_key: :user_id, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :recoverable,
         :validatable

  def author_of?(resource)
    resource.user_id == id
  end
end
