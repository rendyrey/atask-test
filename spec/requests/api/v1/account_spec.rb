# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AccountController, type: :controller do
  include JwtToken

  let(:account) { create(:account) }
  let(:token) { jwt_encode({ account_id: account.id }) }

  describe "GET /api/v1/accounts" do
    before do
      create_list(:account, 25)
    end

    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it "returns paginated accounts on page 1" do
        get :get, params: { page: 1, per_page: 10 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['meta']['total_pages']).to eq(3)
        expect(json_response['meta']['current_page']).to eq(1)
        expect(json_response['meta']['next_page']).to eq("http://test.host/api/v1/accounts?page=2&per_page=10")
        expect(json_response['meta']['prev_page']).to eq(nil)
      end

      it "respects custom per_page parameter" do
        get :get, params: { page: 1, per_page: 5 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['meta']['total_pages']).to eq(6)
        expect(json_response['meta']['current_page']).to eq(1)
        expect(json_response['meta']['next_page']).to eq("http://test.host/api/v1/accounts?page=2&per_page=5")
        expect(json_response['meta']['prev_page']).to eq(nil)
      end
    end

    context "without authentication" do
      it "returns unauthorized status" do
        get :get, params: { page: 1, per_page: 10 }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      before do
        request.headers['Authorization'] = "Bearer invalid_token"
      end

      it "returns unauthorized status" do
        get :get, params: { page: 1, per_page: 10 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/accounts/info" do
    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it "returns account info" do
        get :show

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['email']).to eq(account.email)
        expect(json_response.key?('wallets')).to eq(true)
      end
    end

    context "with invalid token" do
      before do
        request.headers['Authorization'] = "Bearer invalid_token"
      end

      it "returns unauthorized status" do
        get :show

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/accounts" do
    it "successfully create account" do
      post :create, params: { name: "Test", email: 'test@example', password: 'password' }

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)

      expect(json_response['error']).to eq(false)
      expect(json_response['message']).to eq("Account created successfully")
      expect(json_response['account']['email']).to eq('test@example')
    end
  end

  describe "GET /api/v1/accounts/balance" do
    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it "returns account balance" do
        get :account_balance

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq(false)
        expect(json_response['balance_info'].first['wallet_entity']).to eq(account.wallets.first.entity.entity_name)
        expect(json_response['balance_info'].first['wallet_balance']).to eq(account.wallets.first.balance.to_f)
      end
    end
  end

  describe "GET /api/v1/accounts/wallets" do
    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it "returns account wallets" do
        get :account_wallets

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response.first['id']).to eq(account.wallets.first.id)
        expect(json_response.first['entity_id']).to eq(account.wallets.first.entity_id)
        expect(json_response.first['balance']).to eq(account.wallets.first.balance.to_f)
      end
    end
  end
end
