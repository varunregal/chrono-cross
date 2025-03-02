class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps
    end
    add_index :events, :url, unique: true
  end
end
