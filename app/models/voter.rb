require 'provider_client'
require 'csv'
class Voter < ApplicationRecord
  def self.import_from_csv(file)
    voters = []
    csv = CSV.new(file, headers: true)
    csv.each do |row|
      voter = row.to_h
      if !voter["id"]
        raise InvalidVoterException.new "voters must be registered with an id"
      else
        voter["consumer_id"] = voter.delete "id"
        voters << voter
      end
    end
    voters = self.import voters, on_duplicate_key_update: {conflict_target: "consumer_id", columns: [:first_name, :middle_name, :last_name, :city, :state, :zip, :address, :birth_date]}
    
    ProviderClient.get_status_for_voters(Voter.find(voters.ids))
  end
end


class InvalidVoterException < StandardError
end
