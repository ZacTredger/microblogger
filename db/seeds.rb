User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'password',
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  attributes = { name: name,
                 email: email,
                 password: password,
                 password_confirmation: password }
  attributes.merge(activated: true, activated_at: Time.zone.now) unless
    (n % 13).zero?
  User.create! attributes
end
