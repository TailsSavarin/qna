require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'attachable'
  it_behaves_like 'authorable'

  describe 'associations' do
    it { should have_one(:reward).dependent(:destroy) }
    it { should accept_nested_attributes_for(:reward) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:title) }
  end

  describe '#autosubscribe' do
    let(:question) { build(:question) }

    it 'calls autosubscribe' do
      expect(question).to receive(:autosubscribe)
      question.save!
    end

    it 'subscribes user to the question' do
      question.save!
      expect(question.user).to be_subscribed_to(question)
    end
  end
end
