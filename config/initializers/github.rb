# since github uses oauth 2 (twitter uses oauth 1) we have to
# request the access token as they're short lived
# twitter access token never expires (OAuth1), githubs does (OAuth2)
Github.configure do |config|
  config.client_id        = 'eaf16c457d435e56596e'
  config.client_secret    = 'ca8d99e8f1d77c619f498b9e5921d321c4dcca8e'
end