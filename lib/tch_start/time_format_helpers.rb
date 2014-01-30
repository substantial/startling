module TimeFormatHelpers
  def format_time(time)
    total_hours = time / (60 * 60)
    days = total_hours / 24
    hours = total_hours % 24

    ""
  end
end
