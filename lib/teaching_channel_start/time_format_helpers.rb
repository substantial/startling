module TeachingChannelStart
  module TimeFormatHelpers
    def time_from_now(time)
      total_seconds = Time.now - time

      time_suffix = total_seconds > 0 ? 'ago' : 'from now'
      total_seconds = total_seconds.abs

      total_hours = total_seconds / (60 * 60)

      days = (total_hours / 24).round
      hours = (total_hours % 24).round

      if total_hours < 1
        pretty_time = "less than an hour"
      elsif days > 0
        pretty_time = pluralize(days, 'day', 'days')
        pretty_time << " #{pluralize(hours, 'hour', 'hours')}" if hours > 0
      else
        pretty_time = pluralize(hours, 'hour', 'hours')
      end

      "#{pretty_time} #{time_suffix}"
    end

    def pluralize(n, singular, plural=nil)
      if n == 1
        "1 #{singular}"
      elsif plural
        "#{n} #{plural}"
      else
        "#{n} #{singular}s"
      end
    end
  end
end
