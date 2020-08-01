require 'rails_helper'

feature 'User can delete files from question or answer', %q(
  In order to delete excess or unnecessary files
  As an file's author
  I'd like to be able to delete attached files
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    question.files.attach(create_file_blob(filename: 'test.png'))
  end

  it_behaves_like 'delete file' do
    given(:file_selector) { "#question" }
  end
end
