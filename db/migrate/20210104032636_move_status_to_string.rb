class MoveStatusToString < ActiveRecord::Migration[6.0]
  def up
    change_table :voters do |t|
      t.change :registration_status, :string
    end
  end

  def down
    change_table :voters do |t|
      t.change :registration_status, :integer
    end
  end
end
