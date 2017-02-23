FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password'
    phone_number '555-555-5555'
  end

  factory :task do
    title 'Awesome task'
    description 'My description'
    time Time.now
    days_of_week ["monday", "tuesday"]
  end
end
