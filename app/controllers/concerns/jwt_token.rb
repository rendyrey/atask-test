# frozen_string_literal: true

require "jwt"

module JwtToken
  extend ActiveSupport::Concern
  SECRET_KEY = LOCAL_CONFIG[:secrets][:secret_key_base]

  def jwt_encode(payload, exp: 1.hours.from_now)
    Rails.logger.debug "PAYLOAD: #{payload}"
    payload[:exp] = exp.to_i

    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
