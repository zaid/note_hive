namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Sample User",
                 :email => "user@example.ca",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    10.times do |n|
      name  = Faker::Name.name
      email = "user-#{n+1}@example.ca"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    User.all(:limit => 50).each do |user|
      user.notebooks.create!(:title => Faker::Lorem.sentence(2))
    end
  end
end
