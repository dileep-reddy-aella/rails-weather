require 'rails_helper'

RSpec.describe WeatherService, type: :service do

  before :each do
    api_key = 'weather_api_key'
    allow(Rails.application.credentials).to receive(:open_weather_api_key).and_return(api_key) 
  end

  describe '#call' do
    context 'with valid latitude and longitude' do
      it 'returns weather data' do
        latitude = '12.345'
        longitude = '67.890'

        # Stub the Net::HTTP response to simulate a successful response
        response = double(body: { temperature: 25.5, weather: 'Sunny' }.to_json, is_a?: Net::HTTPSuccess)
        allow(Net::HTTP).to receive(:get_response).and_return(response)

        weather_service = WeatherService.new(latitude: latitude, longitude: longitude)
        weather_data = weather_service.call

        expect(weather_data).to be_a(Hash)
        expect(weather_data['temperature']).to eq(25.5)
        expect(weather_data['weather']).to eq('Sunny')
      end
    end

    context 'with missing latitude or longitude' do
      it 'returns nil' do
        latitude = nil
        longitude = '67.890'

        weather_service = WeatherService.new(latitude: latitude, longitude: longitude)
        weather_data = weather_service.call

        expect(weather_data).to be_nil
      end
    end

    context 'with API call failure' do
      it 'returns nil and logs an error' do
        latitude = '12.345'
        longitude = '67.890'

        # Stub the Net::HTTP response to simulate an unsuccessful response
        response = Net::HTTPBadRequest.new('Error', '400', "Error")
        allow(Net::HTTP).to receive(:get_response).and_return(response)

        weather_service = WeatherService.new(latitude: latitude, longitude: longitude)
        weather_data = weather_service.call

        expect(weather_data).to be_nil
      end
    end
  end
end
