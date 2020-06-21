require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'GET #show' do
    let(:answer) { create(:answer) }

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
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

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
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:answers) { question.answers }

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new Answer in the database' do
          expect {
            post :create, params: { question_id: question,
                                    answer: attributes_for(:answer) }, format: :js
          }.to change(answers, :count).by(1)
        end

        it 'user is author of the answer' do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer) }, format: :js
          expect(user).to be_author_of(assigns(:answer))
        end

        it 'renders create view template' do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not saves answer in the database' do
          expect {
            post :create, params: { question_id: question,
                                    answer: attributes_for(:answer, :invalid) }, format: :js
          }.to_not change(answers, :count)
        end

        it 'renders create view template' do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not saves answer in the database' do
        expect {
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer) }, format: :js
        }.to_not change(answers, :count)
      end

      it 'responses with status 401' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer) }, format: :js
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'authenticated user' do
      context 'auhtor' do
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
          it 'does not changes answer attributes' do
            expect {
              patch :update, params: { id: answer,
                                       answer: attributes_for(:answer, :invalid) }, format: :js
            }.to_not change(answer, :body)
          end

          it 'renders update view template' do
            patch :update, params: { id: answer,
                                     answer: attributes_for(:answer, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end

        context 'non author' do
          before { login(another_user) }

          it 'does not changes answer attributes' do
            expect {
              patch :update, params: { id: answer, answer: { body: 'Edited body' } }, format: :js
            }.to_not change(answer, :body)
          end

          it 'renders update view template' do
            patch :update, params: { id: answer, answer: { body: 'Edited body' } }, format: :js
            expect(response).to render_template :update
          end
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not change answer attributes' do
        expect {
          patch :update, params: { id: answer, answer: { body: 'Edited body' } }, format: :js
        }.to_not change(answer, :body)
      end

      it 'responses with status 401' do
        post :update, params: { id: answer, answer: { body: 'Edited body' } }, format: :js
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'authenticated user' do
      context 'author' do
        before { login(user) }

        it 'deletes answer from the database' do
          expect {
            delete :destroy, params: { id: answer }, format: :js
          }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy view template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non author' do
        before { login(another_user) }

        it "doesn't deletes answer from the database" do
          expect {
            delete :destroy, params: { id: answer }, format: :js
          }.not_to change(Answer, :count)
        end

        it 'renders destroy view template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not deletes answer from the database' do
        expect {
          delete :destroy, params: { id: answer }, format: :js
        }.not_to change(Answer, :count)
      end

      it 'responses with status 401' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST #choose_best' do
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    context 'authenticated user' do
      context 'author' do
        before do
          login(user)
          post :choose_best, params: { id: answer }, format: :js
        end

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'updates best attribute' do
          answer.reload
          expect(answer.best).to eq true
        end

        it 'renders choose_best view template' do
          expect(response).to render_template :choose_best
        end
      end

      context 'non author' do
        before do
          login(another_user)
          post :choose_best, params: { id: answer }, format: :js
        end

        it 'does not updates best attribute' do
          answer.reload
          expect(answer.best).to_not eq true
        end

        it 'renders choose_best view template' do
          expect(response).to render_template :choose_best
        end
      end
    end

    context 'unauthenticated user' do
      before { post :choose_best, params: { id: answer }, format: :js }

      it 'does not updates best attribute' do
        answer.reload
        expect(answer.best).to_not eq true
      end

      it 'responses with status 401' do
        expect(response.status).to eq(401)
      end
    end
  end
end
