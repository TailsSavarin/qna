require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:another_user) { create(:user) }
  let(:another_access_token) { create(:access_token, resource_owner_id: another_user.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_json['short_title']).to eq question.title.truncate(11)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_json) { question_json['answers'].first }

        it 'return list of answers' do
          expect(question_json['answers'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id user_id body best created_at updated_at].each do |attr|
            expect(answer_json[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_json) { json['question'] }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:link) { create(:link, :for_question, linkable: question) }

      before do
        question.files.attach(create_file_blob)

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id user_id title body created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json['user']['id']).to eq question.user.id
      end

      describe 'files' do
        it 'return list of files' do
          expect(question_json['files_url'].size).to eq 1
        end
      end

      describe 'links' do
        let(:link_json) { question_json['links'].first }

        it 'return list of links' do
          expect(question_json['links'].size).to eq 1
        end

        it 'returns all public fields' do
          %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_json) { question_json['comments'].first }

        it 'return list of comments' do
          expect(question_json['comments'].size).to eq 1
        end

        it 'return all public fields' do
          %w[id commentable_type commentable_id user_id body created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:question_json) { json['question'] }

      context 'with valid attributes' do
        let(:valid_request) do
          post api_path, params: { access_token: access_token.token,
                                   question: attributes_for(:question) }, headers: headers
        end

        it 'returns success status' do
          valid_request
          expect(response).to be_successful
        end

        it 'saves a new question in the database' do
          expect { valid_request }.to change(Question, :count).by(1)
        end

        it 'returns all public fields' do
          valid_request
          %w[id user_id title body created_at updated_at].each do |attr|
            expect(question_json[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        let(:invalid_request) do
          post api_path, params: { access_token: access_token.token,
                                   question: attributes_for(:question, :invalid) }, headers: headers
        end

        it 'returns unprocessable_entity status' do
          invalid_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'dose not saves question in the database' do
          expect { invalid_request }.to_not change(Question, :count)
        end

        it 'returns errors message' do
          invalid_request
          expect(json['errors'].first).to eq "Title can't be blank"
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:question_json) { json['question'] }

      context 'author of the question' do
        context 'with valid attributes' do
          before do
            patch api_path, params: { access_token: access_token.token,
                                      id: question,
                                      question: { title: 'NewTitle', body: 'NewBody' } }, headers: headers
          end

          it 'returns success status' do
            expect(response).to be_successful
          end

          it 'changes question attributes' do
            %w[title body].each do |attr|
              expect(question_json[attr]).to eq assigns(:question).send(attr).as_json
            end
          end
        end

        context 'with invalid attributes' do
          let(:invalid_request) do
            patch api_path, params: { access_token: access_token.token,
                                      id: question,
                                      question: attributes_for(:question, :invalid) }, headers: headers
          end

          it 'returns unprocessable_entity status' do
            invalid_request
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'does not change question attributes' do
            expect { invalid_request }.to_not change(question, :title)
          end

          it 'returns errors message' do
            invalid_request
            expect(json['errors'].first).to eq "Title can't be blank"
          end
        end
      end

      context 'not author of the question' do
        let(:invalid_request) do
          patch api_path, params: { access_token: another_access_token.token,
                                    id: question,
                                    question: { title: 'NewTitle', body: 'NewBody' } }, headers: headers
        end

        it 'returns forbidden status' do
          invalid_request
          expect(response).to have_http_status(:forbidden)
        end

        it 'does not change question attributes' do
          expect { invalid_request }.to_not change(question, :title)
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'author' do
        let(:valid_request) do
          delete api_path, params: { access_token: access_token.token,
                                     id: question }, headers: headers
        end

        it 'deletes the question' do
          expect { valid_request }.to change(Question, :count).by(-1)
        end

        it 'returns no content status' do
          valid_request
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'not author of the question' do
        let(:invalid_request) do
          delete api_path, params: { access_token: another_access_token.token,
                                     id: question }, headers: headers
        end

        it 'returns forbidden status' do
          invalid_request
          expect(response).to have_http_status(:forbidden)
        end

        it 'does not delete question' do
          expect { invalid_request }.to_not change(Question, :count)
        end
      end
    end
  end
end
