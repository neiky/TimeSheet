module TimerecordsHelper
  def format_seconds_to_time(seconds)
    return "0:00" unless seconds != 0

    days = seconds.abs/86400.to_i
    hours = (seconds.abs/3600 - days*24).to_i
    minutes = (seconds.abs/60 - (hours*60 + days*1440)).to_i

    days_s = days > 0 ? days.to_s + "d " : ""
    hours_s = "%02d" % hours.to_s
    minutes_s = "%02d" % minutes.to_s
    if seconds > 0 then
      return days_s + hours_s + ":" + minutes_s
    else
      return "-" + days_s + hours_s + ":" + minutes_s
    end
  end

  def current_date
    puts params[:date_search]
    date = Date.today() unless params[:date] or params[:date_search]
    date = Date.strptime(params[:date_search], '%Y-%m-%d') if params[:date_search]
    date = Date.strptime(params[:date], '%Y-%m-%d') if params[:date]

    return date
  end
end
