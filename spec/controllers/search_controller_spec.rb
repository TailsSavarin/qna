require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:service) { double('SearchService') }

    before { allow(SearchService).to receive(:new).with('All', '').and_return(service) }

    it 'calls SearchService' do
      expect(service).to receive(:call)
      get :index, params: { resource: 'All', query: '' }
    end

    it 'renders index template' do
      allow(service).to receive(:call)
      get :index, params: { resource: 'All', query: '' }
      expect(response).to render_template :index
    end
  end
end
