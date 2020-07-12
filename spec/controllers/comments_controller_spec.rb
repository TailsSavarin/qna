require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before do
      login(user)
      get :new, params: { question_id: question }
    end

    it 'assigns a new Comment to @comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'render new view tempalte' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:comments) { question.comments }

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new Comment in the database' do
          expect {
            post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          }.to change(comments, :count).by(1)
        end

        it 'user is author of the comment' do
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment) }, format: :js
          expect(user).to be_author_of(assigns(:comment))
        end

        it 'renders create_comment view template' do
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not saves comment in the database' do
          expect {
            post :create, params: { question_id: question,
                                    comment: attributes_for(:comment, :invalid) }, format: :js
          }.to_not change(comments, :count)
        end

        it 'renders create view template' do
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not saves comment in the database' do
        expect {
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment) }, format: :js
        }.to_not change(comments, :count)
      end

      it 'response with status 401' do
        post :create, params: { question_id: question,
                                comment: attributes_for(:comment) }, format: :js
        expect(response.status).to eq(401)
      end
    end
  end
end
