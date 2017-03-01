class TimeWithZone < ActiveRecord::Type::Time
  def serialize(value)
    Time.parse(value.strftime("%H:%M #{Time.zone.formatted_offset(false)}"))
  end

  def deserialize(value)
    super&.in_time_zone(Time.zone)
  end
end
