# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionController, type: :controller do
  include JwtToken

  let(:account) { create(:account) }
  let(:token) { jwt_encode({ account_id: account.id }) }

  describe "POST /api/v1/transaction/top-up" do
    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it "returns top-up transaction" do
        post :top_up, params: { wallet_id: account.wallets.first.id, amount: 1000 }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq(false)

        expect(account.wallets.first.reload.balance).to eq(1000)
      end
    end
  end

  describe "POST /api/v1/transaction/withdraw" do
    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"

        post :top_up, params: { wallet_id: account.wallets.first.id, amount: 1000 }
      end

      it "success withdraw transaction" do
        post :withdraw, params: { wallet_id: account.wallets.first.id, amount: 800 }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq(false)

        expect(account.wallets.first.balance).to eq(200)
      end
    end

    context "with invalid authentication" do
      before do
        request.headers['Authorization'] = "Bearer invalid_token"
      end

      it "returns unauthorized status" do
        post :withdraw, params: { wallet_id: account.wallets.first.id, amount: 800 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/transaction/transfer" do
    context "with valid authentication" do
      before do
        request.headers['Authorization'] = "Bearer #{token}"

        post :top_up, params: { wallet_id: account.wallets.first.id, amount: 1000 }
      end

      it "success transfer transaction" do
        post :transfer, params: { source_wallet_id: account.wallets.first.id, target_wallet_id: account.wallets.last.id, amount: 800 }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq(false)

        expect(account.wallets.first.balance).to eq(200)
        expect(account.wallets.last.balance).to eq(800)
      end
    end

    context "with invalid authentication" do
      before do
        request.headers['Authorization'] = "Bearer invalid_token"
      end

      it "returns unauthorized status" do
        post :transfer, params: { source_wallet_id: account.wallets.first.id, target_wallet_id: account.wallets.last.id, amount: 800 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
