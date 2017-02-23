require 'rails_helper'

RSpec.feature "User edits a task" do
  scenario "task is updated" do
    user = create(:user)
    task = create(
      :task,
      title: "Old",
      description: "old", user: user,
      time: Time.now.beginning_of_day,
      days_of_week: ["Monday"],
    )
    login_as(user, :scope => :user)

     visit '/tasks'

     find(:css, '.task').click

     fill_in :task_title, with: 'Program Rails'
     fill_in :task_description, with: 'Do some Rails!!'
     select '10', from: "task_time_4i"
     select '01', from: "task_time_5i"
     check 'task_days_of_week_sunday'
     check 'task_days_of_week_thursday'

     click_button 'Update task'

     expect(page).to have_content 'Program Rails'
     expect(page).to have_content 'Do some Rails!!'
     expect(page).to have_content '10:01AM'

     expect(page).to have_css(".day.active", text: "S")
     expect(page).to have_css(".day.active", text: "TH")
  end
end
