require 'rails_helper'

RSpec.describe NewAnswerNoticeService do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question, user: user) }

  it 'sends new answer notice to users who subscribed to the question' do
    expect(NewAnswerNoticeMailer).to receive(:notice).with(user, answer).and_call_original
    NewAnswerNoticeService.send_notice(answer)
  end
end
