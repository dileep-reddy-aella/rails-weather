require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'with valid parameters' do
      it 'assigns data to @weather_presenter and zipcode not present' do
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(LocationService).to receive(:get_zipcode_from_lat_lng).and_return('12345')
        allow(WeatherService).to receive(:new).and_return(double(call: JSON.parse(success_weather_data)))

        get :index, params: { latitude: '10.99', longitude: '44.32' }

        presenter = assigns(:weather_presenter)
        expect(presenter).to be_a(WeatherPresenter)
        expect(presenter.location).to eq('Zocca')
      end

      it 'assigns data to @weather_presenter and zipcode is present' do
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(WeatherService).to receive(:new).and_return(double(call: JSON.parse(success_weather_data)))

        get :index, params: { latitude: '10.99', longitude: '44.32', zipcode: '12345' }

        presenter = assigns(:weather_presenter)
        expect(presenter).to be_a(WeatherPresenter)
        expect(presenter.location).to eq('Zocca')
      end

      it 'sets @is_cached to false' do
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(LocationService).to receive(:get_zipcode_from_lat_lng).and_return('12345')
        allow(WeatherService).to receive(:new).and_return(double(call: JSON.parse(success_weather_data)))

        get :index, params: { latitude: '123', longitude: '456' }

        expect(assigns(:is_cached)).to be(false)
      end
    end

    context 'with cached data' do
      it 'assigns cached data to @weather_presenter' do
        allow(LocationService).to receive(:get_zipcode_from_lat_lng).and_return('12345')
        allow(Rails.cache).to receive(:read).and_return(JSON.parse(success_weather_data))
        get :index, params: { latitude: '123', longitude: '456' }

        expect(assigns(:weather_presenter)).to be_a(WeatherPresenter)
      end

      it 'sets @is_cached to true' do
        allow(LocationService).to receive(:get_zipcode_from_lat_lng).and_return('12345')
        allow(Rails.cache).to receive(:read).and_return(JSON.parse(success_weather_data))

        get :index, params: { latitude: '123', longitude: '456' }

        expect(assigns(:is_cached)).to be(true)
      end
    end

    context 'with missing parameters' do
      it 'should not set weather presenter if data is missing' do
        allow(LocationService).to receive(:get_zipcode_from_lat_lng).and_return('12345')
        allow(WeatherService).to receive(:new).and_return(double(call: nil))
        get :index, params: { latitude: '123' }

        expect(assigns(:weather_presenter)).to be(nil)
      end
    end
  end

  def success_weather_data
    {
      "coord": {
        "lon": 10.99,
        "lat": 44.34
      },
      "weather": [
        {
          "id": 501,
          "main": "Rain",
          "description": "moderate rain",
          "icon": "10d"
        }
      ],
      "base": "stations",
      "main": {
        "temp": 298.48,
        "feels_like": 298.74,
        "temp_min": 297.56,
        "temp_max": 300.05,
        "pressure": 1015,
        "humidity": 64,
        "sea_level": 1015,
        "grnd_level": 933
      },
      "visibility": 10000,
      "wind": {
        "speed": 0.62,
        "deg": 349,
        "gust": 1.18
      },
      "rain": {
        "1h": 3.16
      },
      "clouds": {
        "all": 100
      },
      "dt": 1661870592,
      "sys": {
        "type": 2,
        "id": 2075663,
        "country": "IT",
        "sunrise": 1661834187,
        "sunset": 1661882248
      },
      "timezone": 7200,
      "id": 3163858,
      "name": "Zocca",
      "cod": 200
    }.to_json
  end
end
