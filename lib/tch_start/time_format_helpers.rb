module TimeFormatHelpers
  def format_time(time)
    total_hours = time / (60 * 60)
    return "less than an hour" if total_hours < 1

    days = (total_hours / 24).round
    hours = (total_hours % 24).round

    if days > 0
      pretty_time = "#{days} days"
      pretty_time << " and #{hours} hours" if hours > 0
      pretty_time
    else
      "#{hours} hours"
    end
  end
end
