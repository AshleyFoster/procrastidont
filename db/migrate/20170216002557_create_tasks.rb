class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.time :time, null: false

      t.timestamps
    end

    add_column :tasks, :days_of_week, :text, default: [], array: true
  end
end
