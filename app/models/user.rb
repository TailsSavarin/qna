class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
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

  def voted_for?(resource)
    resource.votes.exists?(user_id: id)
  end
end
