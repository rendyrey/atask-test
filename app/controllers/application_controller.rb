# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JwtToken
  before_action :authenticate_user

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      @decoded = jwt_decode(token)
      @current_user = Account.select(:id, :name, :email).find(@decoded[:account_id])
    rescue => e
      render json: { error: true, message: e.message }, status: :unauthorized
    end
  end
end
