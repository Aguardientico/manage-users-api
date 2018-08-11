require 'rails_helper'

RSpec.describe 'Sessions API' do
  describe 'sign_in' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      before do
        post '/api/sign_in', params: { email: user.email, password: user.password }
      end

      it { expect(response).to have_http_status(:success) }
      it do
        body = nil
        expect { body = JSON.parse(response.body).with_indifferent_access }.not_to raise_error
        expect(body).to eq(user.as_json)
        expect(response.headers['Token']).to eq(user.jwt_token)
      end
    end
  end
end
