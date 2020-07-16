require 'rails_helper'

shared_examples_for 'attachable' do
  let(:model) { described_class }

  describe 'associations' do
    it 'have many attached files' do
      expect(model.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
