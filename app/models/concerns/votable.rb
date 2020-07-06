module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:vote_count)
  end

  def create_vote_up(user)
    votes.create(user: user, vote_count: 1)
  end

  def create_vote_down(user)
    votes.create(user: user, vote_count: -1)
  end

  def make_revote(user)
    votes.find_by(user: user)&.destroy
  end
end
