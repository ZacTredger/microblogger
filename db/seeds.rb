require_relative 'helpers.rb'
password = 'password'
User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: password,
             password_confirmation: password,
             admin: true,
             created_at: 50.weeks.ago,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  activated = !(n % 13).zero?
  User.create!(name: Faker::Name.name,
               email: "example-#{n}@railstutorial.org",
               password: password,
               password_confirmation: password,
               activated: activated,
               activated_at: activated ? Time.zone.now : nil)
end

users = User.take(5)
50.times do
  users.each do |user|
    user.posts.create!(content: random_short_lorem,
                       created_at: random_created_at)
  end
end

# Following relationships
users = User.all
user  = users.first
users[2..50].each { |followed| user.follow(followed) }
users[3..40].each { |follower| follower.follow(user) }
