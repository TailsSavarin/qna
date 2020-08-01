shared_examples 'votes features' do
  context 'as user', :js do
    context 'not author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'sees total votes and links' do
        within votable_selector.to_s do
          expect(page).to have_content '0'
          expect(page).to have_link 'Up'
          expect(page).to have_link 'Down'
        end
      end

      scenario 'vote up' do
        within votable_selector.to_s do
          click_on 'Up'
          expect(page).to have_content '1'
          expect(page).to_not have_link 'Up'
          expect(page).to have_content 'Revote'
        end
      end

      scenario 'vote down' do
        within votable_selector.to_s do
          click_on 'Down'
          expect(page).to have_content '-1'
          expect(page).to_not have_link 'Down'
          expect(page).to have_content 'Revote'
        end
      end
    end

    context 'revote' do
      given!(:vote) { create(:vote, user: user, votable: votable) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'revote' do
        within votable_selector.to_s do
          click_on 'Revote'
          expect(page).to have_content '0'
          expect(page).to have_link 'Up'
          expect(page).to have_link 'Down'
          expect(page).to_not have_link 'Revote'
        end
      end
    end

    context 'as author' do
      background do
        sign_in(votable.user)
        visit question_path(question)
      end

      it_behaves_like 'cannot vote for'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'cannot vote for'
  end
end

shared_examples 'cannot vote for' do
  scenario 'sees no links' do
    within votable_selector.to_s do
      expect(page).to have_content '0'
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Reovte'
    end
  end
end
