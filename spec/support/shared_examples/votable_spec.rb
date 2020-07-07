require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:revote) { votable.revote(user) }
  let(:vote_up) { votable.vote_up(user) }
  let(:vote_down) { votable.vote_down(user) }
  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#rating' do
    it 'return total rating of votes' do
      expect(votable.rating).to eq(0)
      vote_up
      expect(votable.rating).to eq(1)
    end
  end

  describe '#vote_up' do
    it 'creates vote with value of 1' do
      vote_up
      expect(votable.rating).to eq(1)
    end
  end

  describe '#vote_down' do
    it 'creates vote with value of -1' do
      vote_down
      expect(votable.rating).to eq(-1)
    end
  end

  describe '#revote' do
    it 'refresh votes' do
      expect(votable.rating).to eq(0)
      vote_up
      expect(votable.rating).to eq(1)
      revote
      expect(votable.rating).to eq(0)
    end
  end
end
