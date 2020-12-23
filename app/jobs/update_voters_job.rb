class UpdateVotersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ProviderClient.get_voter_updates()
  end
end
