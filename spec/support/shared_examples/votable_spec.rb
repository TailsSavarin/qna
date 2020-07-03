require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:revote) { votable_class.make_revote(user.id) }
  let(:vote_up) { votable_class.create_vote_up(user.id) }
  let(:vote_down) { votable_class.create_vote_down(user.id) }
  let(:votable_class) { create(model.to_s.underscore.to_sym) }

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#rating' do
    it 'return total rating of votes' do
      expect(votable_class.rating).to eq(0)
      vote_up
      expect(votable_class.rating).to eq(1)
    end
  end

  describe '#create_vote_up' do
    it 'creates vote with value of 1' do
      vote_up
      expect(votable_class.rating).to eq(1)
    end
  end

  describe '#create_vote_down' do
    it 'creates vote with value of -1' do
      vote_down
      expect(votable_class.rating).to eq(-1)
    end
  end

  describe '#make_revote' do
    it 'refresh votes' do
      expect(votable_class.rating).to eq(0)
      vote_up
      expect(votable_class.rating).to eq(1)
      revote
      expect(votable_class.rating).to eq(0)
    end
  end
end
