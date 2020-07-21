require 'rails_helper'
require 'http'

RSpec.describe ProviderClient, type: :model do
  describe "#get_status_for_voters" do
    let (:voters) do
      5.times do |i|
        i % 2 == 0 ? Voter.create : Voter.create(provider_id: i)
      end
      Voter.all
    end

    it "registers new voters" do
      expected_voters = voters.where(provider_id: nil)

      expect(HTTP).to receive(:post).with(/voters/, hash_including(body: expected_voters.to_json))
      ProviderClient.get_status_for_voters(voters)
    end

    it "returns the voters with the updated status based on the response" do
      pending
      allow(HTTP).to_recieve(:post).and_return(response_json)

      expect(ProviderClient.get_status_for_voters(voters)).to eq expected_voters
    end
  end

end
