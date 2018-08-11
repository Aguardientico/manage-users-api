User.create(first_name: 'Admin', last_name: 'Admin', is_admin: true, email: 'admin@example.org', password: 'password')
100.times do
  User.create(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          job_title: Faker::Job.title,
          is_admin: false,
          email: Faker::Internet.safe_email,
          password: 'password'
  )
end