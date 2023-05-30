# frozen_string_literal: true

require 'rails_helper'
require_relative '../dummies/device'
require_relative '../../app/services/device_service'
require_relative '../../app/adapters/device_model_adapter'

RSpec.describe DeviceService do
  describe 'create_device' do
    let(:device_model_adapter) { instance_double('DeviceModelAdapter', create: device_dummy) }
    let(:valid_params) { { serial_number: 'abc123', firmware_version: 'v1.2' } }
    let(:device_dummy) { DeviceDummy.new(valid_params) }

    before do
      described_class.device = device_model_adapter
    end

    it 'success' do
      device = described_class.create_device(valid_params)
      expect(device.serial_number).to eq('abc123')
    end
  end

  describe 'validate_token_registration' do
    let(:valid_token) { 'abc123321cba' }
    let(:invalid_token) { 'abc123abc123' }
    let(:serial_number) { 'abc123' }

    it 'return success' do
      validation = described_class.validate_token_registration(serial_number, valid_token)
      expect(validation).to eq(true)
    end

    it 'return fail' do
      validation = described_class.validate_token_registration(serial_number, invalid_token)
      expect(validation).to eq(false)
    end
  end

  describe 'find_device_by_token' do
    let(:device_model_adapter) { instance_double('DeviceModelAdapter', create: device_dummy) }
    let(:valid_params) { { serial_number: 'abc123', firmware_version: 'v1.2' } }
    let(:device_dummy) { DeviceDummy.new(valid_params) }

    before do
      described_class.device = device_model_adapter
    end

    it 'return a device with valid token' do
      allow(device_model_adapter).to receive(:find_by_token).and_return(device_dummy)
      device_found = described_class.find_device_by_token('valid_token')
      expect(device_found).to eq(device_dummy)
    end

    it 'return a nil with invalid token' do
      allow(device_model_adapter).to receive(:find_by_token).and_return(nil)
      device_found = described_class.find_device_by_token('invalid_token')
      expect(device_found).to eq(nil)
    end
  end

  describe 'char_average_readings' do
    let(:reading_model_adapter) { instance_double('ReadingModelAdapter') }
    let(:average_data) { { '20-09-03' => 23.2, '20-09-04' => 19.5 } }
    let(:param) { :temperature }
    let(:device_dummy) { DeviceDummy.new({ serial_number: 'abc123', firmware_version: 'v1.2' }) }
    let(:readings) { [ReadingDummy.new({}), ReadingDummy.new({})] }

    before do
      described_class.reading = reading_model_adapter
      allow(reading_model_adapter).to receive(:order_by_day_average).with(readings, param).and_return(average_data)
      allow(device_dummy).to receive(:readings).and_return(readings)
    end

    it 'return average params data' do
      average = described_class.char_average_readings(device_dummy, param)
      expect(average).to eq(average_data)
    end
  end
end
