class PostgresFriendlyTimeZone < ActiveRecord::Type::String
  def serialize(value)
    ActiveSupport::TimeZone::MAPPING[value]
  end

  def deserialize(value)
    ActiveSupport::TimeZone::MAPPING.invert[value]
  end
end
