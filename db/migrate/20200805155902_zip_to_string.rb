class ZipToString < ActiveRecord::Migration[6.0]
  def change
    change_column :voters, :zip, :string
  end
end
