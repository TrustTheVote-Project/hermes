class Voter < ApplicationRecord
  require 'csv'

  def self.import_from_csv(file)
    voters = []
    csv = CSV.new(file, headers: true)
    csv.each do |row|
      voter = row.to_h
      if !voter["id"]
        raise InvalidVoterException.new "voters must be registered with an id"
      else
        voter[:consumer_id] = voter.delete "id"
        voters << voter
      end
    end
    self.import voters, on_duplicate_key_update: {conflict_target: [:consumer_id]}
  end
end


class InvalidVoterException < StandardError
end
