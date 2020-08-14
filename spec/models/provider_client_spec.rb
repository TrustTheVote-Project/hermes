require 'rails_helper'
require 'http'
require 'fixture_helper'

RSpec.describe ProviderClient, type: :model do
  describe "#register_voters" do
    let (:voters) do
      2.times do |i|
        i % 2 == 0 ? Voter.create : Voter.create(provider_id: "00000000-0000-0000-0000-000000000000")
      end
      Voter.all
    end

    before do 
      allow(ProviderClient).to receive(:provider_update)
    end

    it "updates voters with provider ids" do
      response_json = read_fixture('alloy/voters_post_response')
      expect(voters.count).to eq 2
      expect(ProviderClient).to receive(:provider_update).with(/voters/, anything).and_return(OpenStruct.new({body: response_json}))
      expect{ProviderClient.register_voters(voters)}.to change {Voter.where(provider_id: nil).count}.to(0)
    end
    
    it "updates voters with statuses" do
      response_json = read_fixture('alloy/voters_response')
      expect(voters.count).to eq 2

      expect(ProviderClient).to receive(:provider_get).with(/voters/, anything).and_return(OpenStruct.new({body: response_json}))
      expect{ProviderClient.verify_voters(voters)}.to change {Voter.where(registration_status: nil).count}
    end
  end
end
