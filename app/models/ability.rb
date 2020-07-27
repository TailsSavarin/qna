# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User
    can :create, [Question, Answer, Comment, Subscription]
    can %i[update destroy], [Question, Answer], user_id: user.id
    can %i[vote_up vote_down revote], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end
    can :choose_best, Answer, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end

  def guest_abilities
    can :read, :all
  end
end
