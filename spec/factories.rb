FactoryBot.define do
  factory :task do
    title { "Test Task" }
    content  { "Test Task Content" }
    start_at { Time.zone.now }
    end_at { Time.zone.now + 1.day }
    priority { 1 }
    status { 1 }
  end

  factory :user do
    title { "Test User"}
  end
end
