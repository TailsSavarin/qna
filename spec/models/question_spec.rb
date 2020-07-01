require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:reward).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for(:links) }
  it { should accept_nested_attributes_for(:reward) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:title) }
  end

  describe '#votes_counter' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:votes) { create_list(:vote, 5, vote_count: 1, user: user, votable: question) }

    it 'counts votes' do
      expect(question.votes_counter).to eq 5
    end
  end
end
