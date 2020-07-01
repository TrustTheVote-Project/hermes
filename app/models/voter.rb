class Voter < ApplicationRecord
  require 'csv'

  def self.import_from_csv(file)
    voters = []
    CSV.foreach(file, headers: true) do |row|
      voters << row.to_h
    end
    self.import(voters)
  end
end
