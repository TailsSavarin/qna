require 'rails_helper'

feature 'User can vote for answer', %q(
  In order to highlight it
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  it_behaves_like 'votes features' do
    given(:votable_selector) { "#answer-#{answer.id}" }
    given(:votable) { answer }
  end
end
