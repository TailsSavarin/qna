shared_examples_for 'linkable' do
  describe 'associations' do
    it { should accept_nested_attributes_for :links }
    it { should have_many(:links).dependent(:destroy) }
  end
end
