class AllowNonUniqueProviderIds < ActiveRecord::Migration[6.0]
  def change
    remove_index :voters, :provider_id
    add_index :voters, :provider_id
  end  
end
