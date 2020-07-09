class AddForiegnIdsToVoters < ActiveRecord::Migration[6.0]
  def change
    add_column :voters, :consumer_id, :string
    add_column :voters, :provider_id, :string
    add_index :voters, :consumer_id, :unique => true
    add_index :voters, :provider_id, :unique => true
  end
end
