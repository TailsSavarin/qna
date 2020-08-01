shared_examples 'files features', :js do
  background do
    sign_in(user)
    background_info
  end

  scenario 'add files' do
    within filable_selector do
      attach_file 'File', [
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
      ]
    end

    filable_btn

    expect(page).to have_content 'test.jpg'
    expect(page).to have_content 'test.png'
  end
end
