module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:vote_count)
  end

  def create_vote_up(current_user_id)
    votes.find_or_create_by(user_id: current_user_id) { |c| c.vote_count = 1 }
  end

  def create_vote_down(current_user_id)
    votes.find_or_create_by(user_id: current_user_id) { |c| c.vote_count = -1 }
  end

  def make_revote(current_user_id)
    votes.find_by(user_id: current_user_id)&.destroy
  end
end
