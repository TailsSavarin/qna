require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question) { create(:question) }
  let(:ordinary_link) { create(:link, :for_question, linkable: question) }
  let(:gist_link) { create(:link, :for_question, linkable: question, url: 'https://gist.github.com/Test/123') }

  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
    it { should allow_values('http://google.com', 'https://google.com').for(:url) }
  end

  describe '#gist?' do
    it 'returns true if link is a gist' do
      expect(gist_link).to be_gist
    end

    it 'returns false if link is not a gist' do
      expect(ordinary_link).to_not be_gist
    end
  end

  describe '#gist_parse' do
    it 'return last part of the gist url' do
      expect(gist_link.gist_parse).to eq('123')
    end
  end
end
