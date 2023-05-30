# frozen_string_literal: true

require 'rails_helper'
require 'json_web_token'

RSpec.describe 'Readings Reporting' do
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:device) { create(:device) }
  let(:data) do
    {
      readings: [
        {
          temperature: '33.5',
          humidity: '44.7',
          co_level: '1.4',
          health: 'ok',
          timestamp: DateTime.now.strftime('%FT%T')
        }
      ]
    }
  end

  context 'when the request is unauthorized' do
    let(:token) { nil }

    it 'does not record any data' do
      expect { put '/api/v1/reading', params: data, headers: headers }.not_to change(Reading, :count)
    end

    it 'returns 401 Unauthorized' do
      put '/api/v1/reading', params: data.to_json, headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when the request is authorized' do
    let(:token) { JsonWebToken.encode({ id: device.id }) }

    it 'records the data' do
      expect do
        put '/api/v1/reading', params: data, headers: headers
      end.to change(Reading, :count).by(1)
    end

    it 'returns 204 (no content)' do
      put '/api/v1/reading', params: data, headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
