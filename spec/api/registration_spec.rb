require 'rails_helper'

RSpec.describe 'Registration API' do
  describe 'sign_up' do
    context 'with valid params' do
      before do
        post '/api/sign_up', params: { email: 'john.doe@example.org', password: 'password' }
      end

      it { expect(response).to have_http_status(:success) }
      it do
        body = nil
        expect { body = JSON.parse(response.body).with_indifferent_access }.not_to raise_error
        expect(body.keys).to match_array(%w[first_name last_name job_title email hashed_id is_admin])
        expect(response.headers['Token']).to_not be_nil
      end
    end
  end
end
