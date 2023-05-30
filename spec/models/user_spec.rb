# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to respond_to(:first_name) }
  it { is_expected.to respond_to(:last_name) }
  it { is_expected.to respond_to(:email) }

  describe '#full_name' do
    it 'concatenates first and last name' do
      u = create(:user)
      expect(u.full_name).to eql("#{u.first_name} #{u.last_name}")
    end
  end
end
