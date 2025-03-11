# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "POST /api/v1/login" do
    before do
      @account = create(:account, email: 'test@example.com', password: 'password')
    end

    context "when email and password are correct" do
      it "returns a token" do
        post "/api/v1/login", params: { email: 'test@example.com', password: 'password' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['token']).to be_present

        expect(json_response['email']).to eq('test@example.com')
      end
    end

    context "when email and password are incorrect" do
      it "returns an error" do
        post "/api/v1/login", params: { email: 'test1@example.com', password: 'wrong_password' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
