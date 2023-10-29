# Weather Object to structure the weather information
class WeatherPresenter
  def initialize(weather_data)
    @weather_data = weather_data
  end

  def location
    @weather_data['name']
  end

  def date
    Date.current.strftime('%A, %d %B')
  end

  def temperature
    "#{@weather_data['main']['temp']}°C"
  end

  def high_temperature
    "#{@weather_data['main']['temp_max']}°C"
  end

  def low_temperature
    "#{@weather_data['main']['temp_min']}°C"
  end

  def weather_description
    @weather_data['weather'].first['description']
  end

  def weather_icon
    "https://openweathermap.org/img/wn/#{@weather_data['weather'].first['icon']}@2x.png"
  end
end
