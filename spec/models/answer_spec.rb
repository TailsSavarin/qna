require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:another_user) { create(:user) }

  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'attachable'
  it_behaves_like 'authorable'
  it_behaves_like 'commentable'

  describe '.default scope' do
    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'sorts the list, first answer have best attr eq ture' do
      expect(question.answers.first).to eq best_answer
    end
  end

  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe '#select_best' do
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:reward) { create(:reward, user: another_user, question: question) }
    let!(:best_answer) { create(:answer, user: another_user, question: question, best: true) }

    it 'selects answer as best' do
      answer.select_best

      expect(best_answer.reload.best).to be false
      expect(answer.reload.best).to be true
    end

    it 'gives user reward for best answer' do
      answer.select_best

      expect(user.rewards.first).to eq reward
      expect(another_user.rewards.count).to eq 0
    end
  end

  describe '#send_notice' do
    let(:answer) { build(:answer) }

    it 'calls NewAnswerNoticeJob' do
      expect(NewAnswerNoticeJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
