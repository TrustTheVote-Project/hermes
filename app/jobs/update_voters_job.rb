class UpdateVotersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    repeat 'every day at 8am' #GMT

    updated = ProviderClient.get_voter_updates()
  end
end
