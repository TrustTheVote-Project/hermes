class AddVoterContactInformation < ActiveRecord::Migration[6.0]
  def change
    add_column :voters, :email_address, :string
    add_column :voters, :phone, :string
    add_column :voters, :phone_type, :string
    add_column :voters, :partner_name, :string
    add_column :voters, :address_line_2, :string
    add_column :voters, :is_previous, :boolean
  end
end
