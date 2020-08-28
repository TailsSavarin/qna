shared_examples 'link adding features', :js do
  given(:bad_url) { 'www.google.com' }
  given(:good_url) { 'https://www.google.com' }
  given(:gist_url) { 'https://gist.github.com/TailsSavarin/e9b5462d68fe140c4baf0ccc1d3569aa' }

  background do
    sign_in(user)
    background_info
  end

  scenario 'adds link with valid data' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Link Name', with: 'Google'
      fill_in 'Link URL', with: good_url
    end

    linkable_btn

    expect(page).to have_link 'Google', href: good_url
  end

  scenario 'adds link with invalid data' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Name', with: 'Google'
      fill_in 'URL', with: bad_url
    end

    linkable_btn

    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'adds link gist' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Name', with: 'Gist'
      fill_in 'URL', with: gist_url
    end

    linkable_btn

    expect(page).to have_content '1 hosted with ❤ by GitHub'
  end
end

shared_examples 'link deleting features', :js do
  given(:good_url) { 'https://www.google.com' }

  background do
    sign_in(user)
    background_info
  end

  scenario 'deletes link' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Link Name', with: 'Google'
      fill_in 'Link URL', with: good_url
      click_on 'Remove Link'
      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_link 'Remove Link'
    end

    linkable_btn

    expect(page).to_not have_link 'Google', href: good_url
  end
end
