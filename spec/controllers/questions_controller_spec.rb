require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user1) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 5, author: user1) }

    before { get :index }

    it 'assigns all Questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, author: user1) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user1)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user1) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user1) }

    context 'authenticated user is an author' do
      before { login(user1) }

      it 'deletes question from the database' do
        expect {
          delete :destroy, params: { id: question }
        }.to change(user1.authored_questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'authenticated user is not an author' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'does not delete quesiton from the database' do
        expect {
          delete :destroy, params: { id: question }
        }.not_to change(user1.authored_questions, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'unathenticated user' do
      it 'does not delete quesiton from the database' do
        expect {
          delete :destroy, params: { id: question }
        }.not_to change(user1.authored_questions, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
