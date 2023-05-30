# frozen_string_literal: true

class UsersController < ApplicationController
  private

  def users
    @users ||= User.all
  end
  helper_method :users
end
