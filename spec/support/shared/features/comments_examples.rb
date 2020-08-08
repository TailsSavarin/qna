shared_examples 'comments adding features' do
  context 'as user', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds comment with valid data' do
      within add_comment do
        click_on 'Add a comment'
      end
      within commentable_selector do
        fill_in :comment_body, with: 'Test comment'
        click_on 'Post Your Comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'adds comment with invalid data' do
      within add_comment do
        click_on 'Add a comment'
      end
      within commentable_selector do
        fill_in :comment_body, with: ''
        click_on 'Post Your Comment'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  context 'as guest' do
    scenario 'can not see add comment link' do
      visit question_path(question)
      within add_comment do
        expect(page).to_not have_link 'Add a comment'
      end
    end
  end
end
