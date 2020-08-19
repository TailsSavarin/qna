require 'rails_helper'

feature 'User can vote for question', "
  In order to highlight it
  As user
  I'd like to be able to vote
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  it_behaves_like 'votes features' do
    given(:votable_selector) { '.question-votes-rating' }
    given(:votable) { question }
  end
end
