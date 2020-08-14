require 'provider_client'
require 'csv'
class Voter < ApplicationRecord
  enum registration_status: { 
    "Active" => 0,
    "Cancelled" => 1,
    "Suspense" => 2,
    "Purged" => 3,
    "Inactive" => 4,
    "Not Reported" => 5,
    "Provisional" => 6,
    "Preregistered" => 7,
    "Removed" => 8
  }
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
    
    voters = Voter.find(voters.ids)
    VerifyVotersJob.perform_later(voters)
  end
end


class InvalidVoterException < StandardError
end
