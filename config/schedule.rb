set :chronic_options, hours24: true

env :PATH, ENV['PATH']

# By default this would run the job every day at 3am
every 1.day, at: '08:00' do
  runner "ImportVotersJob.perform_now"
  runner "UpdateVotersJob.perform_now"
end