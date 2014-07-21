require 'dotenv'
require 'forecast_io'

class User
  attr_accessor :name, :contact_info

  def initialize(name, contact_info, location)
    @name = name
    @contact_info = contact_info
  end
end

class GddRecord
  attr_accessor :name, :start_date, :target_gdd, :location, :user, :reset_dates
  def initialize(name, start_date, target_gdd, location, user)
    @name = name
    @start_data = start_date
    @target_gdd = target_gdd
    @location = location
    @user = user
    @reset_dates = []
  end

  def reset_dates
    @reset_dates ||= []
  end
end

class Forecast
  attr_accessor :lat, :long

  def initialize(lat, long)
    @lat = lat
    @long = long
  end

  def get_seven_day_forecast
    configure_api
    ForecastIO.forecast(lat, long)
  end

  def get_historical_forecast(time_in_int)
    configure_api
    ForecastIO.forecast(lat, long, time: time_in_int)
  end

  def get_todays_forecast
    get_seven_day_forecast[0]
  end

  def configure_api
    Dotenv.load
    ForecastIO.configure do |config|
      config.api_key = ENV['FORECAST']
      config.default_params = {   units: "si",
                                exclude: "currently,minutely,hourly,alerts,flags" }
    end
  end
end

class WeatherCalculation
  attr_accessor :weather, :daily_max_temp, :daily_min_temp

  def initialize(weather_data)
    @weather = weatherify(weather_data)
    @daily_max_temp = weather[:daily_max_temp]
    @daily_min_temp = weather[:daily_min_temp]
  end

  def weatherify(weather_data)
    { daily_max_temp: weather_data["temperatureMax"], daily_min_temp: weather_data["temperatureMin"] }
  end

  def gdd
    (daily_max_temp + daily_min_temp) / 2 - 10
  end
end
