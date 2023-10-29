# Service to Fetch weather for a give lat, long
class WeatherService
  attr_reader :latitude, :longitude, :units

  BASE_URL = 'https://api.openweathermap.org/data/2.5/weather'.freeze

  def initialize(latitude:, longitude:, units: 'metric')
    @latitude = latitude
    @longitude = longitude
    @units = units
  end

  def call
    return if latitude.blank? || longitude.blank?

    fetch_weather
  rescue e
    Rails.logger.error(e) # You can send this to Sentry
  end

  private

  def fetch_weather
    # Fetch Weather info from OpenWeather API
    response = Net::HTTP.get_response(uri)
    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def uri
    return @uri if defined?(@uri)

    @uri = URI(BASE_URL)
    params = { lat: latitude, lon: longitude, appid: api_key, units: }
    @uri.query = URI.encode_www_form(params)
    @uri
  end

  def api_key
    @api_key ||= Rails.application.credentials.open_weather_api_key
  end
end
