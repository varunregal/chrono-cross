class CreateTimeSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :time_slots do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
