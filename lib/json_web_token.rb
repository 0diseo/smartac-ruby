# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secret_key_base).first
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError
      nil
    end
  end
end
