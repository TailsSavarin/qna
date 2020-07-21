require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 5) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'assigns new comment for answer' do
      expect(assigns(:answer).comments.first).to be_a_new(Comment)
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link for @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new reward for @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'assigns a new votes for @question' do
      expect(assigns(:question).votes.first).to be_a_new(Vote)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question, user: user) }

    context 'authorized user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect {
            post :create, params: { question: attributes_for(:question) }
          }.to change(Question, :count).by(1)
        end

        it 'user is author of the question' do
          post :create, params: { question: attributes_for(:question) }
          expect(user).to be_author_of(assigns(:question))
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

        it 'renders new template' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'unauthorized user' do
      it 'does not saves question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to_not change(Question, :count)
      end

      it 'redirects to sign in view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }

    context 'authorized user' do
      context 'author of the question' do
        before { login(user) }

        context 'with valid attributes' do
          before do
            patch :update, params: { id: question, question: { title: 'NewTitle', body: 'NewBody' } }, format: :js
          end

          it 'changes question attributes' do
            question.reload

            expect(question.title).to eq 'NewTitle'
            expect(question.body).to eq 'NewBody'
          end

          it 'renders update template' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change question attributes' do
            expect {
              patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
            }.to_not change(question, :title)
          end

          it 'renders update template' do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end
      end

      context 'not author of the question' do
        before { login(another_user) }

        it 'does not change question attributes' do
          expect {
            patch :update, params: { id: question, question: { title: 'NewTitle' } }, format: :js
          }.to_not change(question, :title)
        end

        it 'return forbidden status' do
          patch :update, params: { id: question, question: { title: 'NewTitle' } }, format: :js
          expect(response).to have_http_status(:forbidden) # 403
        end
      end
    end

    context 'unauthorized user' do
      it 'does not change question attributes' do
        expect {
          patch :update, params: { id: question, question: { title: 'NewTitle' } }, format: :js
        }.to_not change(question, :title)
      end

      it 'return forbidden status' do
        patch :update, params: { id: question, question: { title: 'NewTitle' } }, format: :js
        expect(response).to have_http_status(:forbidden) # 403
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:another_question) { create(:question) }
    let!(:question) { create(:question, user: user) }

    context 'authorized user' do
      context 'author of the question' do
        before { login(user) }

        it 'deletes question from the database' do
          expect {
            delete :destroy, params: { id: question }
          }.to change(Question, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'not author of the question' do
        before { login(another_user) }

        it 'does not delete quesiton from the database' do
          expect {
            delete :destroy, params: { id: another_question }
          }.not_to change(Question, :count)
        end

        it 'redirects to sign in view' do
          delete :destroy, params: { id: another_question }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context 'unauthorized user' do
      it 'does not delete quesiton from the database' do
        expect {
          delete :destroy, params: { id: question }
        }.not_to change(Question, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
