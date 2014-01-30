module TimeFormatHelpers
  def time_from_now(time)
    total_seconds = (Time.now - time).abs
    total_seconds = total_seconds.abs

    total_hours = total_seconds / (60 * 60)
    return "less than an hour ago" if total_hours < 1

    days = (total_hours / 24).round
    hours = (total_hours % 24).round

    if days > 0
      pretty_time = "#{days} days"
      pretty_time << " #{hours} hours" if hours > 0
      pretty_time << " ago"
    else
      "#{hours} hours ago"
    end
  end
end
