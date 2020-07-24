require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question) { questions.first }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question_json) { json['questions'].first }
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
      let(:access_token) { create(:access_token) }
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
      let(:access_token) { create(:access_token) }

      context 'with valid parameters' do
        it 'returns success status' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
          expect(response).to be_successful
        end

        it 'creates a new question' do
          expect {
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
          }.to change(Question, :count).by(1)
        end

        it 'returns all public fields' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
          %w[id user_id title body created_at updated_at].each do |attr|
            expect(question_json[attr]).to eq Question.first.send(attr).as_json
          end
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable_entity status' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'dose not creates a new question' do
          expect {
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          }.to_not change(Question, :count)
        end

        it 'returns errors message' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          expect(json['errors'].first).to eq "Title can't be blank"
        end
      end
    end
  end
end
