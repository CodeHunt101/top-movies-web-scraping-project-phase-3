class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.text :note_message
      t.integer :movie_id

      t.timestamps
    end
  end
end
