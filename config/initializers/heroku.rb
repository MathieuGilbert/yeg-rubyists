config.after_initialize do
  Delayed::Job.scaler = :heroku_cedar
end