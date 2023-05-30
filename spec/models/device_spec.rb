# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:valid_params) { { serial_number: 'abc123', firmware_version: 'v1.2' } }

  it { is_expected.to respond_to(:serial_number) }
  it { is_expected.to respond_to(:firmware_version) }

  describe 'serial_number'  do
    let(:invalid_params) { { serial_number: '', firmware_version: 'v1.2' } }

    it 'validate with right params' do
      device = described_class.create(valid_params)
      expect(device.valid?).to eq(true)
    end

    it 'validate with bad params' do
      device = described_class.create(invalid_params)
      expect(device.valid?).to eq(false)
    end
  end
end
