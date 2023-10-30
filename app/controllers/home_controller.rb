# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    latitude = params[:latitude]
    longitude = params[:longitude]
    zipcode = params[:zipcode]

    # Fetch zipcode from lat & long (For caching)
    # Google Places Autocomplete API doesn't always return Zipcode
    if zipcode.blank? && latitude.present? && longitude.present?
      zipcode = LocationService.get_zipcode_from_lat_lng(latitude:, longitude:)
    end

    cache_key = "weather_#{zipcode}"

    data, @is_cached = fetch_data_with_cache(latitude, longitude, cache_key)
    @weather_presenter = WeatherPresenter.new(data) if data
  end

  private

  def fetch_data_with_cache(latitude, longitude, cache_key)
    cached_data = Rails.cache.read(cache_key)

    if cached_data
      # Data is available in the cache
      [cached_data, true]
    else
      # Data is not in the cache, fetch and store it
      fresh_data = WeatherService.new(latitude: latitude, longitude: longitude).call
      Rails.cache.write(cache_key, fresh_data, expires_in: 30.minutes)
      [fresh_data, false]
    end
  end
end
