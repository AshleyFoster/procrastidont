desc "Sends text messages to users based on tasks"
task :send_reminder_texts => :environment do
  ReminderTexts.new.send_reminders
end
