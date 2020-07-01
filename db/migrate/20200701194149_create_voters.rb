class CreateVoters < ActiveRecord::Migration[6.0]
  def change
    create_table :voters do |t|
      t.text :first_name
      t.text :last_name
      t.text :address
      t.date :birth_date
      t.text :state
      t.text :city
      t.integer :zip
      t.integer :registration_status
      t.boolean :permanent_absentee

      t.timestamps
    end
  end
end
