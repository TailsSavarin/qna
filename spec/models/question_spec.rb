require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:title) }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for(:links) }
end
