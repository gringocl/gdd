require 'minitest/autorun'
require 'json'

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

  def gdd_celcius
    ((daily_max_temp + daily_min_temp) / 2 - 10).round(2)
  end

  def gdd_fahrenheit
    (gdd_celcius * (9/5.to_f)).round(2)
  end
end

describe WeatherCalculation do
  let(:weather_data) { JSON.parse File.read('seven_day_forecast.json') }
  let(:weather) { WeatherCalculation.new(weather_data["daily"]["data"][0]) }

  it "should initialize with a daily_max_temp and daily_min_temp" do
    weather.daily_max_temp.must_be_kind_of Numeric
    weather.daily_min_temp.must_be_kind_of Numeric
  end

  it "should calculate a gdd_celcius" do
    weather.gdd_celcius.must_be_kind_of Numeric
    weather.gdd_celcius.must_equal 5.66
  end

  it "should calculate a gdd_fahrenheit" do
    weather.gdd_fahrenheit.must_be_kind_of Numeric
    weather.gdd_fahrenheit.must_equal 10.19
  end
end
