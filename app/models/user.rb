class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :recoverable,
         :validatable,
         :omniauthable,
         omniauth_providers: [:github]

  def author_of?(resource)
    resource.user_id == id
  end

  def voted_for?(resource)
    resource.votes.exists?(user_id: id)
  end
end
