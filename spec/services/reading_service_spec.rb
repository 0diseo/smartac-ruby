# frozen_string_literal: true

require_relative '../dummies/reading'
require_relative '../../app/services/reading_service'
require_relative '../dummies/device'
require 'rails_helper'

RSpec.describe ReadingService do
  describe 'save_readings' do
    let(:device) { create(:device) }
    let(:read_dummy) { ReadingDummy.new(valid_params[0]) }
    let(:read_dummy2) { ReadingDummy.new(valid_params[1]) }
    let(:params) { instance_double('Hash') }
    let(:valid_params) do
      [
        {
          temperature: '22.3',
          humidity: '53.7',
          co_level: '2.812',
          health: 'ok',
          recorded_at: '2020-09-03T12:25:13.231Z'
        },
        {
          temperature: '25.9',
          humidity: '53.8',
          co_level: '2.413',
          health: 'needs_service',
          recorded_at: '2020-09-03T12:26:12.428Z'
        }
      ]
    end

    before do
      reading_adapter = instance_double('ReadingModelAdapter')
      described_class.reading = reading_adapter
      allow(reading_adapter).to receive(:create)
      allow(params).to receive(:map).and_return([read_dummy, read_dummy2])
    end

    it 'is save whitout errors' do
      reads = described_class.save_readings(params, device)
      expect(reads).to include(read_dummy, read_dummy2)
    end

    it 'are not saved and return reading with errors' do
      allow(read_dummy).to receive(:errors).and_return([])
      allow(read_dummy2).to receive(:errors).and_return(['blank parameter'])
      reads = described_class.save_readings(params, device)
      expect(reads[0].errors).to eq(['blank parameter'])
    end

    it 'only return the the reading with errors' do
      allow(read_dummy).to receive(:errors).and_return([])
      allow(read_dummy2).to receive(:errors).and_return(['blank parameter'])
      reads = described_class.save_readings(params, device)
      expect(reads.length).to eq(1)
    end
  end

  describe 'reformat_params' do
    let(:params) { { humidity: '53.7', timestamp: '2020-09-03T12:25:13.231Z' } }
    let(:device_dummy) { DeviceDummy.new({ id: 16, serial_number: 'abc123', firmware_version: 'v1.2' }) }
    let(:reformat_params) { described_class.reformat_params(params, device_dummy) }

    specify { expect(reformat_params[:timestamp]).to eq(nil) }
    specify { expect(reformat_params[:recorded_at]).to eq('2020-09-03T12:25:13.231Z') }
    specify { expect(reformat_params[:device_id]).to eq(16) }
    specify { expect(reformat_params[:humidity]).to eq('53.7') }
  end

  describe 'get_device_from_token' do
    let(:device_model_adapter) { instance_double('DeviceModelAdapter', create: device_dummy) }
    let(:valid_params) { { serial_number: 'abc123', firmware_version: 'v1.2' } }
    let(:device_dummy) { DeviceDummy.new(valid_params) }

    before do
      described_class.device = device_model_adapter
    end

    it 'return a device with valid token' do
      allow(device_model_adapter).to receive(:find_by_token).and_return(device_dummy)
      device_found = described_class.get_device_from_token('valid_token')
      expect(device_found).to eq(device_dummy)
    end

    it 'return a nil with invalid token' do
      allow(device_model_adapter).to receive(:find_by_token).and_return(nil)
      device_found = described_class.get_device_from_token('invalid_token')
      expect(device_found).to eq(nil)
    end
  end
end
