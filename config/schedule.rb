
set :chronic_options, hours24: true

# By default this would run the job every day at 3am
every 1.day, at: '1:00' do
  runner "ImportVotersJob.perform_now"
  runner "UpdateVotersJob.perform_now"
end