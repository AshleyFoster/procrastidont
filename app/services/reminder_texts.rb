class ReminderTexts
  def initialize(client = nil)
    @client = client || Twilio::REST::Client.new
  end

  def send_reminders
    tasks.each do |task|
      @client.messages.create(
        from: ENV["TWILIO_FROM"],
        to: task.user.phone_number,
        body: task.description,
      )

      task.update(last_sent_at: DateTime.current.in_time_zone(task.user.time_zone))
    end
  end

  private

  def tasks
    Task.
      joins(:user).
      where("trim(both from to_char(current_timestamp at time zone users.time_zone, 'day')) = ANY(days_of_week)").
      where("time <= current_time at time zone users.time_zone").
      where("last_sent_at IS NULL OR last_sent_at < (current_timestamp at time zone users.time_zone)::date")
  end
end
