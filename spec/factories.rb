FactoryGirl.define do
  factory :member do
    name                  "Sample Member"
    email                 "member@example.com"
    password              "password"
    password_confirmation "password"
    remember_me           false
    twitter               "http://www.twitter.com/sample"
    github                "http://www.github.com/sample"
    blogrss               "http://www.blog.com/sample.rss"
    status                "approved"
  end
  
  
end

Factory.sequence :email do |n|
  "member-#{n}@example.com"
end
