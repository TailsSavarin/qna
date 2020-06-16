require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 5) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question, user: user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new Question in the database' do
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
      it "doesn't save the question" do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.to_not change(Question, :count)
      end

      it 'renders new view template' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }

    context 'author' do
      before { login(user) }

      context 'with valid attributes' do
        before do
          patch :update, params: { id: question,
                                   question: { title: 'Edited title', body: 'Edited body' } }, format: :js
        end

        it 'changes question atrributes' do
          question.reload
          expect(question.title).to eq 'Edited title'
          expect(question.body).to eq 'Edited body'
        end

        it 'renders updated view template' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it "doesn't change question attributes" do
          expect {
            patch :update, params: { id: question,
                                     question: attributes_for(:question, :invalid) }, format: :js
          }.to_not change(question, :title)
        end

        it 'renders update view template' do
          patch :update, params: { id: question,
                                   question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'non author' do
      before { login(other_user) }

      it "doesn't change question attributes" do
        expect {
          patch :update, params: { id: question, question: { title: 'Edited title' } }, format: :js
        }.to_not change(question, :title)
      end

      it 'renders update view template' do
        patch :update, params: { id: question, question: { title: 'Edited title' } }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let!(:another_question) { create(:question) }

    context 'author' do
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

    context 'non author' do
      before { login(user) }

      it "doesn't delete quesiton from the database" do
        expect {
          delete :destroy, params: { id: another_question }
        }.not_to change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: another_question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'DELETE #delete_file' do
    let(:question) { create(:question, user: user) }

    before { question.files.attach(create_file_blob) }

    context 'author' do
      before { login(user) }

      it 'deletes file from the database' do
        expect {
          delete :delete_file, params: { id: question, file_id: question.files.first }, format: :js
        }.to change(question.files, :count).by(-1)
      end

      it 'render delete_file view template' do
        delete :delete_file, params: { id: question, file_id: question.files.first }, format: :js
        expect(response).to render_template :delete_file
      end
    end

    context 'non author' do
      before { login(other_user) }

      it "dosen't delete file from the database" do
        expect {
          delete :delete_file, params: { id: question, file_id: question.files.first }, format: :js
        }.to_not change(question.files, :count)
      end

      it 'render delete_file view template' do
        delete :delete_file, params: { id: question, file_id: question.files.first }, format: :js
        expect(response).to render_template :delete_file
      end
    end
  end
end
