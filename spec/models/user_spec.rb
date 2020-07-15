require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:another_question) { create(:question) }
  let(:question) { create(:question, user: user) }

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
  end

  describe '.find_for_oauth' do
    let!(:user) {create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauthSerivce') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author_of?' do
    it 'author of the resource' do
      expect(user).to be_author_of(question)
    end

    it 'not author of the resource' do
      expect(user).not_to be_author_of(another_question)
    end
  end

  describe '#voted_for?' do
    let!(:vote) { create(:vote, user: user, votable: another_question) }

    it 'voted for the resource' do
      expect(user).to be_voted_for(another_question)
    end

    it 'not voted for the resource' do
      expect(user).to_not be_voted_for(question)
    end
  end
end
