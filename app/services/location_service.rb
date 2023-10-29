# Get details about location
class LocationService
  # Fetch zipcode from latitude & longitude
  def self.get_zipcode_from_lat_lng(latitude:, longitude:)
    return if latitude.blank? || longitude.blank?

    result = Geocoder.search([latitude, longitude])
    if result.blank?
      Rails.logger.error("Geocoding failed: No results for lat: #{latitude}, long: #{longitude}")
    else
      result.first.data['address']['postcode']
    end
  end

  # Not used
  # This was added as an initial setup, wherein GoogleMaps APIs are not used
  def self.get_lat_lng(address)
    cache_key = "location_#{address}"
    result = Rails.cache.read(cache_key)

    if result.blank?
      result = Geocoder.search(address)
      if result.blank? || result.first.data['lat'].blank? || result.first.data['lon'].blank?
        handle_geocoding_error(result, address) and return
      end

      Rails.cache.write(cache_key, result, expires_in: 30.minutes)
    end

    OpenStruct.new(latitude: result.first.data['lat'], longitude: result.first.data['lon'])
  end

  def self.handle_geocoding_error(result, address)
    if result.blank?
      Rails.logger.error("Geocoding failed: No results for address '#{address}'")
    else
      Rails.logger.error("Geocoding failed: Incomplete data for address '#{address}'")
    end
  end
end
