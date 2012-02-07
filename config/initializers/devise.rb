Devise.setup do |config|
  require 'devise/orm/active_record'
  
  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [ :email ]
  
  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [ :email ]
  
  # If true, uses the password salt as remember token. This should be turned
  # to false if you are not using database authenticatable.
  config.use_salt_as_remember_token = true
  
  # Time interval you can reset your password with a reset password key.
  # Don't put a too small interval or your users won't have the time to
  # change their passwords.
  config.reset_password_within = 2.hours
  
end