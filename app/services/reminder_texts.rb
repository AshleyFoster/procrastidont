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

      task.update(last_sent_at: Date.today)
    end
  end

  private

  def tasks
    today = Date.today.strftime("%A").downcase
    time = Time.current
    beginning_of_day = Date.today.beginning_of_day

    Task.
      joins(:user).
      where("? = ANY(days_of_week)", today).
      where("time <= timezone(users.time_zone, ?)::time", time).
      where("last_sent_at IS NULL OR last_sent_at < ?", beginning_of_day)
  end
end
