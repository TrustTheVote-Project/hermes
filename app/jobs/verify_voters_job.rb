class VerifyVotersJob < ApplicationJob
  queue_as :default

  def perform(voters)
    ProviderClient.register_voters(voters)
    ProviderClient.verify_voters(voters)
  end
end
