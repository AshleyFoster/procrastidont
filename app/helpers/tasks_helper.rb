module TasksHelper
  def day_to_short_day(day)
    case day
    when "Monday"
      "M"
    when "Tuesday"
      "T"
    when "Wednesday"
      "W"
    when "Thursday"
      "TH"
    when "Friday"
      "F"
    when "Saturday"
      "S"
    when "Sunday"
      "SU"
    end
  end
end
