require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'default scope' do
    let(:answers) { create(:answer, 5) }
    it 'sorts the list in descending by best attribute and creation time' do
      expect(Answer.all.to_sql).to eq Answer.order('best desc, created_at').to_sql
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#choose_best' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:another_answer) { create(:answer, question: question, best: true) }

    it 'choose current answer like best' do
      expect(answer).to_not be_best
      answer.select_best
      expect(answer).to be_best
    end

    it 'choose other answer like best' do
      expect(answer).to_not be_best
      expect(another_answer).to be_best
      answer.select_best
      answer.reload
      another_answer.reload
      expect(answer).to be_best
      expect(another_answer).to_not be_best
    end
  end

  it { should accept_nested_attributes_for :links }
end
