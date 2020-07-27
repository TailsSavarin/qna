require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #subscribe' do
    let(:data_request) do
      post :create, params: { question_id: question }, format: :js
    end

    context 'authenticated user' do
      before { login(user) }

      it 'creates subscription' do
        expect { data_request }.to change(user.subscriptions, :count).by(1)
      end

      it 'returns status success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'unauthenticated user' do
      it 'does not create subscription' do
        expect { data_request }.to_not change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        data_request
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end
end
