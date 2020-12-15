class DefaultCreatedAtForVoters < ActiveRecord::Migration[6.0]
  def change
    change_column_default :voters, :created_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
