require "rails_helper"

RSpec.describe ReminderTexts do
  DAY_NAMES = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

  describe "#send_reminders" do
    it "sends texts to correct number with correct description" do
      user = create(:user, time_zone: "UTC")
      task = create(:task, time: Time.current - 1.minute, days_of_week: DAY_NAMES, user: user)
      twilio_client = mock_twilio_client
      reminder = ReminderTexts.new(twilio_client)

      reminder.send_reminders

      expect(twilio_client.messages).to have_received(:create).once
      expect(twilio_client.messages).to have_received(:create).with(
        from: ENV["TWILIO_FROM"],
        to: task.user.phone_number,
        body: task.description,
      )
    end

    it "does not send same reminder twice" do
      user = create(:user, time_zone: "UTC")
      task = create(:task, time: Time.current - 1.minute, days_of_week: DAY_NAMES, user: user)
      twilio_client = mock_twilio_client
      reminder = ReminderTexts.new(twilio_client)

      reminder.send_reminders
      reminder.send_reminders

      expect(twilio_client.messages).to have_received(:create).once
    end

    it "does not send reminder if task time is after now" do
      scheduled_time = Time.now + 10.minutes
      task = create(:task, time: scheduled_time, days_of_week: DAY_NAMES)
      twilio_client = mock_twilio_client
      reminder = ReminderTexts.new(twilio_client)

      reminder.send_reminders

      expect(twilio_client.messages).not_to have_received(:create)
    end

    it "sends reminder using correct time zone" do
      Time.use_zone "UTC" do
        scheduled_at = Time.current - 6.hours
        user = create(:user, time_zone: "Eastern Time (US & Canada)")
        task = create(:task, user: user, time: scheduled_at, days_of_week: DAY_NAMES)
        twilio_client = mock_twilio_client

        reminder = ReminderTexts.new(twilio_client)
        reminder.send_reminders

        expect(twilio_client.messages).to have_received(:create)
      end
    end
  end

  private

  def mock_twilio_client
    double(Twilio::REST::Client).tap do |client|
      messages = double(:messages, create: true)
      allow(client).to receive(:messages).and_return(messages)
    end
  end
end
