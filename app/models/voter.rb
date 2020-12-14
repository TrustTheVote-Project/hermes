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

  def self.import_from_csv(file, states: [])
    voters = []
    csv = CSV.new(file, headers: true)
    csv.each do |row|
      hash = row.to_h
      next unless states.empty? || states.include?(hash["home_state_abbrev"].to_s)
      voters << format_voters(hash)
    end
    voters = self.import voters, on_duplicate_key_update: {conflict_target: "consumer_id", columns: [:first_name, :middle_name, :last_name, :city, :state, :zip, :address, :birth_date]}
    
    voters = Voter.find(voters.ids)
    VerifyVotersJob.perform_later(voters)
  end

  def self.format_voters(voter) 
    raise InvalidVoterException.new "voters must be registered with an id" unless voter["id"] || voter["uid"]
    
    voter_hash = {
      first_name: voter["first_name"],
      middle_name: voter["middle_name"],
      last_name: voter["last_name"],
      address: voter["address"] || voter["home_address"],
      address_line_2: voter["address_line_2"] || voter["home_unit"],
      birth_date: format_birth_date(voter),
      state: voter["state"] || voter["home_state_abbrev"],
      city: voter["city"] || voter["home_city"],
      zip: voter["zip"] || voter["home_zip_code"],
      permanent_absentee: voter["permanent_absentee"],
      consumer_id: voter["uid"] || voter["id"],
      email_address: voter["email_address"],
      phone: voter["phone"],
      phone_type: voter["phone_type"],
      partner_name: voter["partner_name"],
    }
  end
  
  def self.format_birth_date(voter)
    return voter["birth_date"] if voter["birth_date"]
    "#{voter["date_of_birth_year"]}-#{voter["date_of_birth_month"]}-#{voter["date_of_birth_day"]}"
  end
end

class InvalidVoterException < StandardError
end
