require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:other_answer) { create(:answer, question: question) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #show' do
    before do
      login(user)
      get :show, params: { id: answer }
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new, params: { question_id: question }
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'authenticated user is author of the answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(user).to be_author_of(assigns(:answer))
      end

      it 'renders create view template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it "doesn't save answer in the database" do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        }.to_not change(question.answers, :count)
      end

      it 'renders create view template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'Edited body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'Edited body'
      end

      it 'renders update view template' do
        patch :update, params: { id: answer, answer: { body: 'Edited body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with ivalid attributes' do
      it "doesn't change answer attributes" do
        expect {
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        }.to_not change(answer, :body)
      end

      it 'renders update view template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user is an author' do
      before { login(user) }

      it 'deletes answer from the database' do
        expect {
          delete :destroy, params: { id: answer }, format: :js
        }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to  render_template :destroy
      end
    end

    context 'authenticated user is not an author' do
      before { login(user) }

      it "doesn't delete answer from the database" do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'renders destroy view template' do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'unauthenticated user' do
      it "doesn't delete answer from the database" do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #choose_best' do
    before { login(user) }

    context 'author of the question' do
      before { post :choose_best, params: { id: answer }, format: :js }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'update best attribute' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render choose_best template' do
        expect(response).to render_template :choose_best
      end
    end

    context 'non author of the question' do
      before { post :choose_best, params: { id: other_answer }, format: :js }
      it "doesn't update best attribute" do
        answer.reload
        expect(answer.best).to_not eq true
      end

      it ' render choose_best template' do
        expect(response).to render_template :choose_best
      end
    end
  end
end
