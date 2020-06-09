require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:authored_questions).dependent(:destroy) }
  end
end
