module TimerecordsHelper
  def format_seconds_to_time(seconds)
    return "0:00" unless seconds > 0

    days = seconds/86400
    seconds = seconds%86400
    hours = seconds/3600
    seconds = seconds%3600
    minutes = seconds/60
    
    days_s = days > 0 ? days.to_s + "d " : ""
    hours_s = hours < 10 ? hours.to_s : hours.to_s
    minutes_s = minutes < 10 ? "0"+minutes.to_s : minutes.to_s
    
    return days_s + hours_s + ":" + minutes_s
  end
  
  def current_date
    date = Date.today() unless params[:date] or params[:date_search]
    date = Date.strptime(params[:date_search], '%Y-%m-%d') if params[:date_search]
    date = Date.strptime(params[:date], '%Y-%m-%d') if params[:date]
    
    return date
  end
end
