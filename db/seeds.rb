User.create!(name:  "Example User",
             kananame: "わてすと",
             email: "example@railstutorial.org",
             password:              "foobarfoobar",
             password_confirmation: "foobarfoobar",
             adminflg: true,
             bumon_id: 1)

300.times do |n|
  name  = Faker::Name.name
  kananame  = "わてすと"
  email = "example-#{n+1}@railstutorial.org"
  password = "foobarfoobar"
  bumon_id = 1
  User.create!(name:  name,
               kananame: kananame,
               email: email,
               password:              password,
               password_confirmation: password,
               bumon_id: bumon_id)
end