class Voter < ApplicationRecord
  require 'csv'

  def self.import_from_csv(file)
    voters = []
    csv = CSV.new(file, headers: true)
    csv.each do |row|
      voters << row.to_h
    end
    self.import(voters)
  end
end
