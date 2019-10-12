def random_short_lorem
  lorem = Faker::Lorem.sentence(word_count: rand(1..20))
  return lorem if lorem.length < 140

  lorem[0..140].sub(/\s\w*$/, '')
end

def random_created_at
  rand(50).weeks.ago
end

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
