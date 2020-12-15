require 'provider_client'
require 'csv'
class Voter < ApplicationRecord
  has_paper_trail

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
    voters += import_voters(:format_old, file, states)
    voters += import_voters(:format_new, file, states)

    VerifyVotersJob.perform_later(voters)
  end

  private

  def self.import_voters(formatter, file, states)
    voters = []
    csv = CSV.new(file, headers: true)
    csv.each do |row|
      hash = row.to_h
      next unless states.empty? || states.include?(hash["home_state_abbrev"].to_s)
      voter_hash = self.send(formatter, hash)
      voter = Voter.find_or_initialize_by(consumer_id: voter_hash[:consumer_id])
      voter.assign_attributes(voter_hash)
      voter.save
      voters << voter
    end
    voters
  end
  
  def self.format_new(voter)
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
      updated_at: Time.now
    }
  end

  def self.format_old(voter)
    return nil if voter.select{|k,_v| k.match?(/prev/)}.empty?
    voter_hash = {
      first_name: voter["prev_first_name"] || voter["first_name"],
      middle_name: voter["prev_middle_name"] || voter["middle_name"],
      last_name: voter["prev_last_name"] || voter["last_name"],
      address: voter["address"] || voter["prev_address"] || voter["home_address"],
      address_line_2: voter["address_line_2"] || voter["prev_home_unit"] || voter["home_unit"],
      birth_date: format_birth_date(voter),
      state: voter["state"] || voter["prev_home_state_abbrev"] || voter["home_state_abbrev"],
      city: voter["city"] || voter["prev_home_city"] || voter["home_city"],
      zip: voter["zip"] || voter["prev_home_zip_code"] || voter["home_zip_code"],
      permanent_absentee: voter["permanent_absentee"],
      consumer_id: voter["uid"] || voter["id"],
      email_address: voter["email_address"],
      phone: voter["phone"],
      phone_type: voter["phone_type"],
      partner_name: voter["partner_name"],
      is_previous: true,
      updated_at: Time.now
    }
  end
    
  def self.format_birth_date(voter)
    return voter["birth_date"] if voter["birth_date"]
    "#{voter["date_of_birth_year"]}-#{voter["date_of_birth_month"]}-#{voter["date_of_birth_day"]}"
  end
end
