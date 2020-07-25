require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:another_user) { create(:user) }
  let(:another_access_token) { create(:access_token, resource_owner_id: another_user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:answer_json) { json['answers'].first }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'contains user object' do
        expect(answer_json['user']['id']).to eq answer.user.id
      end

      it 'contains short body' do
        expect(answer_json['short_body']).to eq answer.body.truncate(20)
      end

      it 'returns all public fields' do
        %w[id user_id body best rating created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_json['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_json) { json['answer'] }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:link) { create(:link, :for_answer, linkable: answer) }

      before do
        answer.files.attach(create_file_blob)

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id user_id body best rating created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_json['user']['id']).to eq answer.user.id
      end

      describe 'files' do
        it 'return list of files' do
          expect(answer_json['files_url'].size).to eq 1
        end
      end

      describe 'links' do
        let(:link_json) { answer_json['links'].first }

        it 'return list of links' do
          expect(answer_json['links'].size).to eq 1
        end

        it 'returns all public fields' do
          %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_json) { answer_json['comments'].first }

        it 'return list of comments' do
          expect(answer_json['comments'].size).to eq 1
        end

        it 'return all public fields' do
          %w[id commentable_type commentable_id user_id body created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:answer_json) { json['answer'] }

      context 'with valid attributes' do
        let(:valid_request) do
          post api_path, params: { access_token: access_token.token,
                                   question_id: question,
                                   answer: attributes_for(:answer) }, headers: headers
        end

        it 'returns success status' do
          valid_request
          expect(response).to be_successful
        end

        it 'saves a new answer in the database' do
          expect { valid_request }.to change(question.answers, :count).by(1)
        end

        it 'returns all public fields' do
          valid_request
          %w[id user_id body created_at updated_at].each do |attr|
            expect(answer_json[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        let(:invalid_request) do
          post api_path, params: { access_token: access_token.token,
                                   question_id: question,
                                   answer: attributes_for(:answer, :invalid) }, headers: headers
        end

        it 'returns unprocessable_entity status' do
          invalid_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not save answer in the database' do
          expect { invalid_request }.to_not change(question.answers, :count)
        end

        it 'returns errors message' do
          invalid_request
          expect(json['errors'].first).to eq "Body can't be blank"
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }

      context 'authorized' do
        let(:answer_json) { json['answer'] }

        context 'author of the answer' do
          context 'with valid attributes' do
            before do
              patch api_path, params: { access_token: access_token.token,
                                        id: answer,
                                        answer: { body: 'NewBody' } }, headers: headers
            end

            it 'returns success status' do
              expect(response).to be_successful
            end

            it 'changes answer attributes' do
              expect(answer_json['body']).to eq assigns(:answer).body
            end
          end

          context 'with invalid attributes' do
            let(:invalid_request) do
              patch api_path, params: { access_token: access_token.token,
                                        id: answer,
                                        answer: attributes_for(:answer, :invalid) }, headers: headers
            end

            it 'returns unprocessable entity status' do
              invalid_request
              expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'does not change answer attributes' do
              expect { invalid_request }.to_not change(answer, :body)
            end

            it 'returns errors message' do
              invalid_request
              expect(json['errors'].first).to eq "Body can't be blank"
            end
          end
        end

        context 'not author of the answer' do
          let(:invalid_request) do
            patch api_path, params: { access_token: another_access_token.token,
                                      id: answer,
                                      answer: { body: 'NewBody' } }, headers: headers
          end

          it 'returns forbidden status' do
            invalid_request
            expect(response).to have_http_status(:forbidden)
          end

          it 'does not change answer attributes' do
            expect { invalid_request }.to_not change(answer, :body)
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'author of the answer' do
        let(:valid_request) do
          delete api_path, params: { access_token: access_token.token,
                                     id: answer }, headers: headers
        end

        it 'deletes the question' do
          expect { valid_request }.to change(question.answers, :count).by(-1)
        end

        it 'returns no content status' do
          valid_request
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'not author of the answer' do
        let(:invalid_request) do
          delete api_path, params: { access_token: another_access_token.token,
                                     id: answer }, headers: headers
        end

        it 'returns forbidden status' do
          invalid_request
          expect(response).to have_http_status(:forbidden)
        end

        it 'does not delete answer' do
          expect { invalid_request }.to_not change(question.answers, :count)
        end
      end
    end
  end
end
