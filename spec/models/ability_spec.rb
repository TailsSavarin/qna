require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    context 'read' do
      it { should be_able_to :read, Question }
      it { should be_able_to :read, Answer }
      it { should be_able_to :read, Comment }
    end

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:question) { create(:question, user: user) }
    let(:another_answer) { create(:answer, user: another_user) }
    let(:another_question) { create(:question, user: another_user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context 'create' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Comment }
    end

    context 'update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, another_question }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, another_answer }
    end

    context 'destroy' do
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, another_question }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, another_answer }
    end

    context 'vote_up' do
      it { should_not be_able_to :vote_up, question }
      it { should be_able_to :vote_up, another_question }

      it { should_not be_able_to :vote_up, answer }
      it { should be_able_to :vote_up, another_answer }
    end

    context 'vote_down' do
      it { should_not be_able_to :vote_down, question }
      it { should be_able_to :vote_down, another_question }

      it { should_not be_able_to :vote_dowm, answer }
      it { should be_able_to :vote_down, another_answer }
    end

    context 'revote' do
      it { should_not be_able_to :revote, question }
      it { should be_able_to :revote, another_question }

      it { should_not be_able_to :revote, answer }
      it { should be_able_to :revote, another_answer }
    end

    context 'choose_best' do
      it { should be_able_to :choose_best, create(:answer, question: question) }
      it { should_not be_able_to :choose_best, create(:answer, question: another_question) }
    end

    context 'attachments' do
      before do
        answer.files.attach(create_file_blob(filename: 'test.png'))
        question.files.attach(create_file_blob(filename: 'test.jpg'))
        another_answer.files.attach(create_file_blob(filename: 'test.png'))
        another_question.files.attach(create_file_blob(filename: 'test.jpg'))
      end

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, another_question.files.first }

      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, another_answer.files.first }
    end
  end
end
