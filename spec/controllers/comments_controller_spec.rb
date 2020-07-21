require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:comments) { question.comments }

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect {
            post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          }.to change(comments, :count).by(1)
        end

        it 'user is author of the comment' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(user).to be_author_of(assigns(:comment))
        end

        it 'renders create template' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save comment in the database' do
          expect {
            post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          }.to_not change(comments, :count)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save comment in the database' do
        expect {
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        }.to_not change(comments, :count)
      end

      it 'returns unauthorized status' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end
end
