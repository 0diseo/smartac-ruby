# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def notifications
    @notifications ||= user_signed_in? ? current_user.notifications : nil
  end
  helper_method :notifications
end
