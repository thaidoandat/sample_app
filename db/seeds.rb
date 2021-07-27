# Create a main sample user.
User.create!(name: Settings.user.admin.name,
             email: Settings.user.admin.email,
             password: Settings.user.admin.password,
             password_confirmation: Settings.user.admin.password,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  User.create!(name: name,
               email: email,
               password: Settings.user.faker.password,
               password_confirmation: Settings.user.faker.password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each{|user| user.microposts.create!(content: content)}
end

# Create following relationships.
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow followed}
followers.each {|follower| follower.follow user}
