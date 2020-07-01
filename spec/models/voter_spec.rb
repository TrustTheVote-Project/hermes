require 'rails_helper'

RSpec.describe Voter, type: :model do
  describe "#import_from_csv" do
    let(:file) { file_fixture("sampe_voters_import.csv") }
    it 'creates models for each voter' do
      expect{ Voter.import_from_csv(file) }.to change{ Voter.all.count }.from(0)
    end
  end
end
