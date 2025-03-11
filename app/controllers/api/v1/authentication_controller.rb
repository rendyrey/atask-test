# frozen_string_literal: true

class Api::V1::AuthenticationController < ApplicationController
  include JwtToken
  skip_before_action :authenticate_user

  def login
    @account = Account.find_by(email: params[:email])

    if @account && @account.authenticate(params[:password])
      token = jwt_encode({ account_id: @account.id })
      time = Time.now + 2.hours.to_i
      render json: {
        token: token,
        exp: time.strftime("%Y-%m-%d %H:%M:%S"),
        email: @account.email
      }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end
end
