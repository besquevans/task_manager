namespace :task do
  desc "Add Admin for userless tasks"
  task add_user: :environment do
    admin = User.find_by(role: "admin")
    Task.where(user: nil).update(user: admin)
  end
end
