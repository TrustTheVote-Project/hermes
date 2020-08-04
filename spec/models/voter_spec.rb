require 'rails_helper'

RSpec.describe Voter, type: :model do
  describe "#import_from_csv" do
    let(:file) { file_fixture("sampe_voters_import.csv").read }
    before do
      allow(ProviderClient).to receive(:get_status_for_voters).and_return(nil)
    end

    it 'creates models for each voter' do
      expect{ Voter.import_from_csv(file) }.to change{ Voter.all.count }.from(0)
    end

    it 'does not create duplicates' do
      expect{ Voter.import_from_csv(file) }.to change{ Voter.all.count }.from(0)
      expect{ Voter.import_from_csv(file) }.to_not change{ Voter.all.count }
    end

    it 'updates existing voters' do
      update = file.gsub('Johnson', 'Irving')
      Voter.import_from_csv(file)

      expect{ Voter.import_from_csv(update) }.to change{ Voter.where(last_name: "Irving").count }.from(0).to(1)
    end
  end
end
