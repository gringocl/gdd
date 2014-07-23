require 'time'

class GddRecord
  attr_accessor :start_date, :alarm_target

  DAYS_IN_SECONDS = 24*60*60

  def initialize(start_date, alarm_target)
    @start_date = start_date
    @alarm_target = alarm_target
  end

  def alarm_target
    @alarm_target ||= 150
  end

  def accumulate
    if start_date.to_date < Time.now.to_date
      historical + forecast
    elsif start_date.to_date == Time.now.to_date
      forecast
    else start_date.to_date > Time.now.to_date
      forecast.pop(get_days_from_today)
    end
  end

  def get_days_from_today
    now_in_int = Time.now.to_i
    start_date_in_int = start_date.to_i
    days = (start_date_in_int - now_in_int)/DAYS_IN_SECONDS
    if days < 0
      return_array_of_times
    else days > 0
      return_num_days_minus_8_from_today
    end
  end


  def historical
    Forecast.new(lat, long).get_days_from_today.reduce do |day, memo|
      memo += Gdd.new(get_historical_forecast(day.to_i)).gdd_celcius
    end
  end

  def forecast
    Forecast.new(lat, long).get_seven_day_forecast.map do |day|
      Gdd.new(day).gdd_celcius
    end
  end
end
