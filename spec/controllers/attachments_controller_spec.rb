require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    before { question.files.attach(create_file_blob) }

    let(:file) { question.files.first }
    let(:files) { question.files }
    let(:request_data) { delete :destroy, params: { id: file }, format: :js }

    context 'authenticated user' do
      context 'author of the question' do
        before { login(user) }

        it 'deletes file from the database' do
          expect { request_data }.to change(ActiveStorage::Attachment, :count).by(-1)
        end

        it 'returns success status' do
          request_data
          expect(response).to have_http_status(:success)
        end

        it 'renders destroy template' do
          request_data
          expect(response).to render_template :destroy
        end
      end

      context 'not author of the question' do
        before { login(another_user) }

        it 'does not delete file from the database' do
          expect { request_data }.to_not change(ActiveStorage::Attachment, :count)
        end

        it 'returns forbidden status' do
          request_data
          expect(response).to have_http_status(:forbidden) # 403
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not delete file from the database' do
        expect { request_data }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'returns unauthorized status' do
        request_data
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end
end
