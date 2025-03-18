class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.references :project, null: false, foreign_key: true
      t.references :assigned_user, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end
  end
end
