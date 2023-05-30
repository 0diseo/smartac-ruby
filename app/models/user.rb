# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :validatable
  acts_as_target

  def full_name
    "#{first_name} #{last_name}"
  end
end
