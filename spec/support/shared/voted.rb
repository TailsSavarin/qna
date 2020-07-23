shared_examples_for 'voted' do
  let(:votable) { create(described_class.controller_name.singularize.to_sym, user: another_user) }

  describe 'POST #vote_up' do
    context 'authenticated user' do
      context 'not author of the votable' do
        before { login(user) }

        it 'creates vote up' do
          expect {
            post :vote_up, params: { id: votable }, format: :json
          }.to change(votable.votes, :count).by(1)
        end

        it 'renders json response with votable id and rating' do
          expected = { id: votable.id, rating: votable.rating + 1 }.to_json

          post :vote_up, params: { id: votable }, format: :json
          expect(response.body).to eq expected
        end
      end

      context 'author of the votable' do
        before { login(another_user) }

        it 'does not create vote up' do
          expect {
            post :vote_up, params: { id: votable }, format: :json
          }.to_not change(votable.votes, :count)
        end

        it 'returns forbidden status' do
          post :vote_up, params: { id: votable }, format: :json
          expect(response).to have_http_status(:forbidden) # 403
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote up' do
        expect {
          post :vote_up, params: { id: votable }, format: :json
        }.to_not change(votable.votes, :count)
      end

      it 'returns unauthorized status' do
        post :vote_up, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end

  describe 'POST #vote_down' do
    context 'authenticated user' do
      context 'not author of the votable' do
        before { login(user) }

        it 'creates vote down' do
          expect {
            post :vote_down, params: { id: votable }, format: :json
          }.to change(votable.votes, :count).by(1)
        end

        it 'renders json response with votable id and rating' do
          expected = { id: votable.id, rating: votable.rating - 1 }.to_json

          post :vote_down, params: { id: votable }, format: :json
          expect(response.body).to eq expected
        end
      end

      context 'author of the votable' do
        before { login(another_user) }

        it 'does not create vote down' do
          expect {
            post :vote_down, params: { id: votable }, format: :json
          }.to_not change(votable.votes, :count)
        end

        it 'returns forbidden status' do
          post :vote_down, params: { id: votable }, format: :json
          expect(response).to have_http_status(:forbidden) # 403
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote down' do
        expect {
          post :vote_down, params: { id: votable }, format: :json
        }.to_not change(votable.votes, :count)
      end

      it 'returns unauthorized status' do
        post :vote_down, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end

  describe 'POST #revote' do
    let!(:vote) { create(:vote, user: user, value: 1, votable: votable) }

    context 'authenticated user' do
      context 'not author of the votable' do
        before { login(user) }

        it 'removes past vote' do
          expect {
            post :revote, params: { id: votable }, format: :json
          }.to change(votable.votes, :count).by(-1)
        end

        it 'renders json response with votable id and rating' do
          post :revote, params: { id: votable }, format: :json

          expected = { id: votable.id, rating: votable.rating }.to_json

          expect(response.body).to eq expected
        end
      end

      context 'author of the question' do
        before { login(another_user) }

        it 'dose not remove past vote' do
          expect {
            post :revote, params: { id: votable }, format: :json
          }.to_not change(votable.votes, :count)
        end

        it 'returns forbidden status' do
          post :revote, params: { id: votable }, format: :json
          expect(response).to have_http_status(:forbidden) # 403
        end
      end
    end

    context 'unauthenticated user' do
      it 'dose not remove past vote' do
        expect {
          post :revote, params: { id: votable }, format: :json
        }.to_not change(votable.votes, :count)
      end

      it 'returns unauthorized status' do
        delete :revote, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end
end
