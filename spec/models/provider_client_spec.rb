require 'rails_helper'
require 'http'
require 'fixture_helper'

RSpec.describe ProviderClient, type: :model do
  describe "#register_voters" do
    before do 
      Voter.create 
      Voter.create(provider_id: "00000000-0000-0000-0000-000000000000")
    end

    it "updates voters with provider ids" do
      response_json = read_fixture('alloy/voters_post_response')
      expect(Voter.count).to eq 2
      expect_any_instance_of(HTTP::Client).to receive(:post).and_return(OpenStruct.new({body: response_json}))
      expect{ProviderClient.register_voters(Voter.all)}.to change {Voter.where(provider_id: nil).count}.to(0)
    end
    
    it "updates voters with statuses" do
      response_json = read_fixture('alloy/voters_response')
      expect(Voter.where(registration_status: nil).count).to eq 2

      expect_any_instance_of(HTTP::Client).to receive(:get).and_return(OpenStruct.new({body: response_json}))
      expect{ProviderClient.verify_voters(Voter.all)}.to change {Voter.where(registration_status: nil).count}
    end
  end
end