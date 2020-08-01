shared_examples 'delete links features', :js do
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
