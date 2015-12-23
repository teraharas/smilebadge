# User.create!(name:  "Example User",
#             kananame: "わてすと",
#             email: "example@railstutorial.org",
#             password:              "foobarfoobar",
#             password_confirmation: "foobarfoobar",
#             adminflg: true,
#             bumon_id: 1)

# 50.times do |n|
#   name  = Faker::Name.name
#   kananame  = "わてすと"
#   email = "example-#{n+1}@railstutorial.org"
#   password = "passtest"
#   bumon_id = 1
#   User.create!(name:  name,
#               kananame: kananame,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               bumon_id: bumon_id)
# end

# users = User.order(:created_at).take(6)
# 20000.times do
#   content = Faker::Lorem.sentence(5)
#   users.each { |user| user.sent_badgeposts.create!(sent_user_id: user.id,
#                           recept_user_id: user.id + 1, badge_id: user.id + 1, content: content) }
# end
