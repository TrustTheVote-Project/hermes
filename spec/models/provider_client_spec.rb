require 'rails_helper'
require 'http'
require 'fixture_helper'

RSpec.describe ProviderClient, type: :model do
  describe "#get_status_for_voters" do
    let (:voters) do
      5.times do |i|
        i % 2 == 0 ? Voter.create : Voter.create(provider_id: i)
      end
      Voter.all
    end

    it "updates voters with provider ids" do
      response_json = read_fixture('alloy/verify')
      expect(voters.count).to eq 5
      expect(ProviderClient).to receive(:provider_get).with(/verify/, anything).at_least(:once).and_return(OpenStruct.new({body: response_json}))
      expect(ProviderClient).to receive(:provider_get).with(/voters/, anything).at_least(:once).and_return(OpenStruct.new({body: response_json}))
      expect{ProviderClient.get_status_for_voters(voters)}.to change {Voter.where(provider_id: nil).count}.to(0)
    end

    it "updates voters with statuses" do
      response_json = read_fixture('alloy/verify')
      expect(voters.count).to eq 5
      expect(ProviderClient).to receive(:provider_get).with(/verify/, anything).at_least(:once).and_return(OpenStruct.new({body: response_json}))
      expect(ProviderClient).to receive(:provider_get).with(/voters/, anything).at_least(:once).and_return(OpenStruct.new({body: response_json}))
      expect{ProviderClient.get_status_for_voters(voters)}.to change {Voter.where(registration_status: nil).count}.to(0)
    end
  end

end
