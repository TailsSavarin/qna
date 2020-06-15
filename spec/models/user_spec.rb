require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_question) { create(:question) }
    let(:user_question) { create(:question, user: user) }

    it 'is the author of the resource' do
      expect(user).to be_author_of(user_question)
    end

    it 'is not the author of the resource' do
      expect(user).not_to be_author_of(another_question)
    end
  end
end
