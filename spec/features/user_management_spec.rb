# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User management', type: :feature do
  let(:admin) { create(:user) }

  before do
    login_as(admin)
  end

  it 'User invites a new user' do
    visit '/users'
    click_link('New User')
    fill_in('Email', with: 'newuser@example.com')
    click_button('Send an invitation')
    expect(page).to have_text('An invitation email has been sent to newuser@example.com')
  end
end
