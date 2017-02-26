class AddLastSentAtToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :last_sent_at, :date
  end
end
