require 'rails_helper'

RSpec.describe Voter, type: :model do
  describe "#import_from_csv" do
    let(:file) { file_fixture("voteready_registrants_2020_11_06_19_01-2020_12_03_14_00.csv").read }
    before do
      allow(ProviderClient).to receive(:register_voters).and_return(nil)
      allow(ProviderClient).to receive(:verify_voters).and_return(nil)
    end

    it 'creates models for each voter' do
      expect{ Voter.import_from_csv(file) }.to change{ Voter.all.count }.from(0)
    end

    it 'does not create duplicates' do
      expect{ Voter.import_from_csv(file) }.to change{ Voter.all.count }.from(0)
      expect{ Voter.import_from_csv(file) }.to_not change{ Voter.all.count }
    end

    it 'updates existing voters' do
      update = file.gsub('Smith', 'Irving')
      Voter.import_from_csv(file)

      sleep 1
      expect{ Voter.import_from_csv(update) }.to change{ Voter.count{|v| v.last_name == "Irving" } }
    end

    it 'filters to specified states' do
      expect{ Voter.import_from_csv(file, states: "GA") }.to change{ Voter.count }.from(0).to(1)
    end

    it 'Creates history for records' do
      Voter.import_from_csv(file, states: "GA")

      expect(Voter.last.versions.length).to be 2
      expect(Voter.last.first_name).to eq "Alex"
    end

    it 'posts changes to sns' do
      allow(Rails.application.credentials).to receive(:config).and_return({test: {aws: true}})
      allow(Rails.application.credentials).to receive("test").and_return({aws: {:sns_region => "region", access_key_id: 123, secret: 456}})
      expect_any_instance_of(Aws::SNS::Client).to receive(:publish)

      v = Voter.create
      v.update(registration_status: "Active")
    end
  end
end
