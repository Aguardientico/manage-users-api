require 'rails_helper'

RSpec.describe UsersController do
  describe '#index' do
    let(:admin) { create(:admin) }

    context 'with valid credentials' do
      before do
        get '/api/users', headers: { Authorization: "Bearer #{admin.jwt_token}" }
      end
      it { expect(response).to have_http_status(:success) }
      it do
        body = nil
        expect { body = JSON.parse(response.body) }.not_to raise_error
        expect(body).to match_array([admin.as_json])
        expect(response.headers['X-Total-Pages']).to eq('1')
      end
    end

    context 'without valid credentials' do
      before { get '/api/users' }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'non admin user' do
      let(:user) { create(:user) }
      before do
        get '/api/users', headers: { Authorization: "Bearer #{user.jwt_token}" }
      end
      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe '#show' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }

    context 'with valid credentials and valid params' do
      before do
        get "/api/users/#{user.hashed_id}",
            headers: { Authorization: "Bearer #{admin.jwt_token}" }
      end
      it { expect(response).to have_http_status(:success) }
      it do
        body = nil
        expect { body = JSON.parse(response.body).with_indifferent_access }.not_to raise_error
        expect(body.keys).to match_array(%w[first_name last_name email job_title hashed_id is_admin])
      end
    end

    context 'with valid credentials but invalid user' do
      before do
        get '/api/users/wrong_hash',
            headers: { Authorization: "Bearer #{admin.jwt_token}" }
      end
      it { expect(response).to have_http_status(:not_found) }
    end

    context 'without valid credentials' do
      before { get "/api/users/#{user.hashed_id}" }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'non admin user' do
      let(:user) { create(:user) }
      before do
        get "/api/users/#{user.hashed_id}",
            headers: { Authorization: "Bearer #{user.jwt_token}" }
      end
      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe '#create' do
    let(:admin) { create(:admin) }

    context 'with valid credentials and valid params' do
      before do
        post '/api/users',
             headers: { Authorization: "Bearer #{admin.jwt_token}" },
             params: { user: {
               first_name: 'John',
               last_name: 'Doe',
               email: 'john.doe@example.org',
               password: 'password'
             } }
      end
      it { expect(response).to have_http_status(:success) }
      it do
        body = nil
        expect { body = JSON.parse(response.body).with_indifferent_access }.not_to raise_error
        expect(body.keys).to match_array(%w[first_name last_name email job_title hashed_id is_admin])
      end
    end

    context 'with valid credentials and invalid params' do
      before do
        post '/api/users',
             headers: { Authorization: "Bearer #{admin.jwt_token}" },
             params: { user: {
               last_name: 'Doe',
               email: 'john.doe@example.org',
               password: 'password'
             } }
      end
      it { expect(response).to have_http_status(:bad_request) }
      it do
        body = nil
        expect { body = JSON.parse(response.body).with_indifferent_access }.not_to raise_error
        expect(body.keys).to match_array(%w[errors])
      end
    end

    context 'without valid credentials' do
      before { post '/api/users' }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'non admin user' do
      let(:user) { create(:user) }
      before do
        post '/api/users', headers: { Authorization: "Bearer #{user.jwt_token}" }
      end
      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe '#update' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }

    context 'with valid credentials and valid params' do
      before do
        patch "/api/users/#{user.hashed_id}",
              headers: { Authorization: "Bearer #{admin.jwt_token}" },
              params: { user: {
                job_title: 'Developer'
              } }
      end
      it { expect(response).to have_http_status(:success) }
      it do
        body = nil
        expect { body = JSON.parse(response.body).with_indifferent_access }.not_to raise_error
        expect(body.keys).to match_array(%w[first_name last_name email job_title hashed_id is_admin])
        expect(body[:job_title]).to eq('Developer')
      end
    end

    context 'with valid credentials but invalid user' do
      before do
        patch '/api/users/wrong_hash',
              headers: { Authorization: "Bearer #{admin.jwt_token}" },
              params: { user: {
                job_title: 'Developer'
              } }
      end
      it { expect(response).to have_http_status(:not_found) }
    end

    context 'with valid credentials but invalid params' do
      before do
        patch "/api/users/#{user.hashed_id}",
              headers: { Authorization: "Bearer #{admin.jwt_token}" },
              params: { user: {
                job_title: 'Developer',
                first_name: ''
              } }
      end
      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'without valid credentials' do
      before { patch "/api/users/#{user.hashed_id}" }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'non admin user' do
      let(:user) { create(:user) }
      before do
        patch "/api/users/#{user.hashed_id}",
              headers: { Authorization: "Bearer #{user.jwt_token}" }
      end
      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe '#delete' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }

    context 'with valid credentials and valid params' do
      before do
        delete "/api/users/#{user.hashed_id}",
               headers: { Authorization: "Bearer #{admin.jwt_token}" }
      end
      it { expect(response).to have_http_status(:success) }
      it { expect(User.count).to be(1) }
    end

    context 'with valid credentials but invalid user' do
      before do
        delete '/api/users/wrong_hash',
               headers: { Authorization: "Bearer #{admin.jwt_token}" }
      end
      it { expect(response).to have_http_status(:not_found) }
    end

    context 'without valid credentials' do
      before { delete "/api/users/#{user.hashed_id}" }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'non admin user' do
      let(:user) { create(:user) }
      before do
        delete "/api/users/#{user.hashed_id}",
               headers: { Authorization: "Bearer #{user.jwt_token}" }
      end
      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
