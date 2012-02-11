namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do
    
    Rake::Task['db:reset'].invoke
    
    make_members
    make_tweets
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
    create_new_user_with_status "pending" 
  end
  
  # 25 approved members
  25.times do |n|
    create_new_user_with_status "approved"
  end
  
end

def make_tweets
  Member.all(:limit => 5).each do |member|
    25.times do
      member.tweets.create!(:username   => member.name,
                            :date       => Time.at(rand * Time.now.to_i),
                            :content    => Faker::Lorem.sentence(10),
                            :url        => "www.zzzz" + Faker::Internet.domain_name)
    end
  end
end

def create_new_user_with_status(status)
  name = Faker::Name.name
  username = name.gsub(/\s+/, '')
  Member.create!( :name                  => name,
                  :email                 => "#{username}@example.com",
                  :password              => "password",
                  :password_confirmation => "password",
                  :twitter               => "twitter_#{username}",
                  :github                => "github_#{username}",
                  :blogrss               => "http://www.#{username}.com/atom",
                  :status                => status )
end
