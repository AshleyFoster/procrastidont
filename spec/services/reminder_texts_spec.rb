require "rails_helper"

RSpec.describe ReminderTexts do
  DAY_NAME = "sunday"

  around(:each) do |example|
    Timecop.freeze Time.new(2017, 01, 01, 8, 00, 44)
    example.run
    Timecop.return
  end

  describe "#send_reminders" do
    it "sends texts to correct number with correct description" do
      task = create(:task, time: Time.now, days_of_week: [DAY_NAME])
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
      task = create(:task, time: Time.now, days_of_week: [DAY_NAME])
      twilio_client = mock_twilio_client
      reminder = ReminderTexts.new(twilio_client)

      reminder.send_reminders
      reminder.send_reminders

      expect(twilio_client.messages).to have_received(:create).once
    end

    it "does not send reminder if task time is after now" do
      scheduled_time = Time.now + 10.minutes
      task = create(:task, time: scheduled_time, days_of_week: [DAY_NAME])
      twilio_client = mock_twilio_client
      reminder = ReminderTexts.new(twilio_client)

      reminder.send_reminders

      expect(twilio_client.messages).not_to have_received(:create)
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
