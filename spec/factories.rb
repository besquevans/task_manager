FactoryBot.define do
  factory :task do
    user { User.first }
    title { "Test Task" }
    content  { "Test Task Content" }
    start_at { Time.zone.now }
    end_at { Time.zone.now + 1.day }
    priority { 1 }
    status { 1 }
  end

  factory :user do
    email { "test@mail.com"}
    password { "123456" }
  end
end
