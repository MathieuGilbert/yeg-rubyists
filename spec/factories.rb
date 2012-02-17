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
    status                "pending"
  end
  
  factory :tweet do
    date        :date_in_last_month
    content     "I really like pies!"
    url         "http://www.twitter.com/sample"
    since_id    '163088974838120448'
    association :member
  end
  
  factory :git_event do
    date        :date_in_last_month
    event       "Pushed to some/repo"
    url         "http://www.github.com/sample"
    association :member
  end
  
  factory :blog_post do
    title       "Post Title"
    summary     "Summary of the blog post."
    date        :date_in_last_month
    url         "http://www.blog.com/sample"
    association :member
  end
  
  factory :date_in_last_month do
    Time.now - (rand * 60 * 60 * 24 * 30)
  end
end

Factory.sequence :email do |n|
  "member-#{n}@example.com"
end
