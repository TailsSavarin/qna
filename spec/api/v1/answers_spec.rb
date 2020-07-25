require 'rails_helper'

describe 'Questions API', type: :request do
  let(:question) { create(:question) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:answer_json) { json['answers'].first }
      let(:access_token) { create(:access_token) }
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
      let(:access_token) { create(:access_token) }
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
end
