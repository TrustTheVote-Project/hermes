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
      update = file.gsub('Mekelburg', 'Irving')
      Voter.import_from_csv(file)

      expect{ Voter.import_from_csv(update) }.to change{ Voter.where(last_name: "Irving").count }.from(0).to(2)
    end
  end
end
