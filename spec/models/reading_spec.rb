# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reading, type: :model do
  it { is_expected.to respond_to(:temperature) }
  it { is_expected.to respond_to(:humidity) }
  it { is_expected.to respond_to(:co_level) }
  it { is_expected.to respond_to(:health) }
  it { is_expected.to respond_to(:recorded_at) }
end
