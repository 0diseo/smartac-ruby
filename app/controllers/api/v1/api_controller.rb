# frozen_string_literal: true

require 'json_web_token'

class Api::V1::ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  private

  def auth_header
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    header&.gsub(pattern, '') if header.match(pattern)
  end
end
