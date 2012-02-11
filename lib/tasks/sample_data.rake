namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do
    
    Rake::Task['db:reset'].invoke
    
    make_members
  end
end

def make_members
  # mat admin
  mat = Member.create!( :name                  => "Mathieu Gilbert",
                        :email                 => "matnarak@gmail.com",
                        :password              => "password",
                        :password_confirmation => "password",
                        :twitter               => "mathieu_gilbert",
                        :github                => "mathieugilbert",
                        :blogrss               => "http://www.helloabs.com/feed/atom",
                        :status                => "approved" )
  mat.toggle!(:admin)
  
  # ryan admin
  ryan = Member.create!( :name                  => "Ryan Jones",
                         :email                 => "ryan.michael.jones@gmail.com",
                         :password              => "password",
                         :password_confirmation => "password",
                         :twitter               => "ryanonrails",
                         :github                => "ryanonrails",
                         :blogrss               => "http://www.ryanonrails.com/feed/atom",
                         :status                => "approved" )
  ryan.toggle!(:admin)
  
  
  # 25 pending members
  25.times do |n|
    Member.create!( :name                  => Faker::Name.name,
                    :email                 => "sample-user-#{n + 1}@example.com",
                    :password              => "password",
                    :password_confirmation => "password",
                    :twitter               => "",
                    :github                => "",
                    :blogrss               => "http://www.google.com",
                    :status                => "pending" )
  end
  
  # 25 approved members
  25.times do |n|
    Member.create!( :name                  => Faker::Name.name,
                    :email                 => "sample-user-#{n + 26}@example.com",
                    :password              => "password",
                    :password_confirmation => "password",
                    :twitter               => "",
                    :github                => "",
                    :blogrss               => "http://www.google.com",
                    :status                => "approved" )
  end
  
  # 25 tweets
  25.times do |n|
    Tweet.create!(  :username              => Faker::Name.name,
                    :date                  => Time.at(rand * Time.now.to_i),
                    :content               => Faker::Lorem.sentence,
                    :url                   => "www.zzzz" + Faker::Internet.domain_name)
  end
  
end