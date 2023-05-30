# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'
require_relative '../../app/adapters/reading_model_adapter'

RSpec.describe ReadingModelAdapter, type: :model do
  describe 'create a Reading' do
    let(:valid_params) do
      {
        temperature: '22.3',
        humidity: '53',
        co_level: '2.8',
        health: 'ok',
        recorded_at: '2020-09-03T12:25:13.231Z'
      }
    end
    let(:device) { described_class.new.create(valid_params) }

    specify { expect(device.class.name).to eq('Reading') }
    specify { expect(device.temperature).to eq(22.3) }
    specify { expect(device.humidity).to eq(53) }
    specify { expect(device.co_level).to eq(2.8) }
    specify { expect(device.health).to eq('ok') }
    specify { expect(device.recorded_at).to eq('2020-09-03T12:25:13.231Z') }
  end

  describe 'order_by_day_average' do
    let(:device) { create(:device) }
    let(:readings) { Reading.all }

    before do
      create(:reading,
             device_id: device.id,
             temperature: '22.3',
             humidity: '53',
             co_level: '2.8',
             recorded_at: '2020-09-03T12:25:13.231Z')
      create(:reading,
             device_id: device.id,
             temperature: '24.1',
             humidity: '40',
             co_level: '1.8',
             recorded_at: '2020-09-03T12:25:13.231Z')
      create(:reading,
             device_id: device.id,
             temperature: '19.5',
             humidity: '20',
             co_level: '0.85',
             recorded_at: '2020-09-04T12:25:13.231Z')
    end

    it 'return a temperature average per day' do
      average = described_class.new.order_by_day_average(readings, :temperature)
      expect(average).to eq({ '20-09-03' => 23.2.to_d, '20-09-04' => 19.5.to_d })
    end

    it 'return a humidity average per day' do
      average = described_class.new.order_by_day_average(readings, :humidity)
      expect(average).to eq({ '20-09-03' => 46.5.to_d, '20-09-04' => 20.to_d })
    end

    it 'return a co_level average per day' do
      average = described_class.new.order_by_day_average(readings, :co_level)
      expect(average).to eq({ '20-09-03' => 2.3.to_d, '20-09-04' => 0.85.to_d })
    end
  end
end
