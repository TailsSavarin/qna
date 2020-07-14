require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#rating' do
    it 'equals to zero' do
      expect(votable.rating).to eq(0)
    end

    it 'equals to sum of votes' do
      create_list(:vote, 2, user: user, votable: votable, value: 1)
      expect(votable.rating).to eq(2)
    end
  end

  describe '#vote_up' do
    it 'creates new vote with value of 1' do
      expect {
        votable.vote_up(user)
      }.to change(votable.votes, :count).by(1)
    end
  end

  describe '#vote_down' do
    it 'creates new vote with value of -1' do
      expect {
        votable.vote_down(user)
      }.to change(votable.votes, :count).by(1)
    end
  end

  describe '#revote' do
    it 'removes vote' do
      create(:vote, user: user, votable: votable)
      expect {
        votable.revote(user)
      }.to change(Vote, :count).by(-1)
    end
  end
end
