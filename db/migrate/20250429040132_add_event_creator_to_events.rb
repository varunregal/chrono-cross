class AddEventCreatorToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :event_creator, null: true, foreign_key: { to_table: :users }
  end
end
