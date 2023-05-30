# frozen_string_literal: true

require 'rails_helper'
require 'json_web_token'

RSpec.describe 'DevicesController' do
  describe 'show' do
    let(:device) { create(:device) }

    context 'when validation success' do
      let(:token) { JsonWebToken.encode({ id: device.id }) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      before do
        get "/api/v1/devices/#{device.id}", headers: headers
      end

      specify { expect(response).to have_http_status(:ok) }
      specify { expect(JSON.parse(response.body)).to eql({ 'token_valid' => true }) }
    end

    context 'when validation fails' do
      let(:token) { JsonWebToken.encode({ id: device.id }) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      before do
        get '/api/v1/devices/a', headers: headers
      end

      specify { expect(response).to have_http_status(:unprocessable_entity) }
      specify { expect(JSON.parse(response.body)).to eql({ 'token_valid' => false }) }
    end
  end

  describe 'create' do
    let(:device) { create(:device) }
    let(:params) do
      {
        device: {
          serial_number: device.serial_number,
          firmware_version: device.firmware_version
        }
      }
    end

    context 'when the request is authorized' do
      let(:token) { device.serial_number + device.serial_number.reverse }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      context 'when registration succeeds' do
        before do
          post '/api/v1/devices', params: params, headers: headers
        end

        specify { expect(response).to have_http_status(:ok) }
        specify { expect(response.content_type).to eql('application/json; charset=utf-8') }

        it 'returns a JWT' do
          json = JSON.parse(response.body)
          expect(json['token']).not_to be_nil
        end
      end

      context 'when registration fails' do
        let(:invalid_params) do
          {
            device: {
              serial_number: device.serial_number,
              firmware_version: nil
            }
          }
        end

        before do
          post '/api/v1/devices', params: invalid_params, headers: headers
        end

        specify { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end

    context 'when the request is not authorized' do
      let(:headers) { { 'Authorization' => 'INVALID' } }

      before do
        post '/api/v1/devices', params: params, headers: headers
      end

      specify { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
