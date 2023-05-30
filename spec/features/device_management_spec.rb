# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Device management', type: :feature do
  let(:admin) { create(:user) }
  let!(:device) { create(:device) }

  before do
    login_as(admin)
  end

  it 'Viewing a device' do
    visit '/devices'
    click_link(device.serial_number)
    expect(page).to have_text('Device Information')
  end
end
