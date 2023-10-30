require 'rails_helper'

RSpec.describe LocationService, type: :service do
  describe '.get_zipcode_from_lat_lng' do
    it 'returns the correct zipcode for give latitude and longitude' do
      latitude = '12.345'
      longitude = '67.890'
      allow(Geocoder).to receive(:search).and_return([double(data: { 'address' => { 'postcode' => '12345' } })])

      zipcode = LocationService.get_zipcode_from_lat_lng(latitude: latitude, longitude: longitude)

      expect(zipcode).to eq('12345')
    end

    it 'returns nil when latitude or longitude is missing' do
      latitude = nil
      longitude = '67.890'

      zipcode = LocationService.get_zipcode_from_lat_lng(latitude: latitude, longitude: longitude)

      expect(zipcode).to be_nil
    end

    it 'when geocoding fails: returns nil and logs an error' do
      latitude = '12.345'
      longitude = '67.890'
      allow(Geocoder).to receive(:search).and_return([])

      expect(Rails.logger).to receive(:error).with("Geocoding failed: No results for lat: 12.345, long: 67.890")

      zipcode = LocationService.get_zipcode_from_lat_lng(latitude: latitude, longitude: longitude)

      expect(zipcode).to be_nil
    end
  end
end
