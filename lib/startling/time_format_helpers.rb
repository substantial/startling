require 'tzinfo'
require 'business_time'

module Startling
  module TimeFormatHelpers
    def business_time_ago(time)
      days = pdt(time).to_date.business_days_until(pdt(Time.now).to_date)

      case days
      when 0
        hours_ago(time)
      else
        "#{pluralize(days, "day")} ago"
      end
    end

    def hours_ago(time)
      total_seconds = Time.now - time
      time_suffix = total_seconds >= 0 ? 'ago' : 'from now'
      total_seconds = total_seconds.abs

      hours = (total_seconds / (60 * 60)).floor

      if hours < 1
        pretty_time = "less than an hour"
      else
        pretty_time = pluralize(hours, 'hour')
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

    def pdt(time)
      tz = TZInfo::Timezone.get('America/Los_Angeles')
      tz.utc_to_local(time)
    end
  end
end
