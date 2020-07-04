require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'attachable'
  it_behaves_like 'authorable'

  describe 'default scopes' do
    let(:answers) { create(:answer, 5) }

    it 'sorts the list in descending by best attribute and creation time' do
      expect(Answer.all.to_sql).to eq Answer.order('best desc, created_at').to_sql
    end
  end

  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe '#select_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:another_user) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:reward) { create(:reward, question: question, user: another_user) }
    let!(:another_answer) { create(:answer, user: another_user, question: question, best: true) }

    it 'select answer like the best' do
      expect(answer).to_not be_best
      answer.select_best
      expect(answer).to be_best
    end

    it 'select another answer like the best' do
      expect(answer).to_not be_best
      expect(another_answer).to be_best
      answer.select_best
      answer.reload
      another_answer.reload
      expect(answer).to be_best
      expect(another_answer).to_not be_best
    end

    it 'assign reward to the answers author' do
      expect(another_user.rewards.first).to eq reward
      expect(reward.user).to_not eq user
      answer.select_best
      answer.reload
      expect(reward.user).to eq user
      expect(another_user.rewards.first).to_not eq reward
    end
  end
end
