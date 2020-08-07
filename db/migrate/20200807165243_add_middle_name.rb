class AddMiddleName < ActiveRecord::Migration[6.0]
  def change
    add_column :voters, :middle_name, :string
  end
end
