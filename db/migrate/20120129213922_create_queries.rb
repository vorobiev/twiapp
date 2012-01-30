class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :name
      t.string :refresh_url
      t.integer :tweet_count
      t.datetime :last_search
      t.references :task

      t.timestamps
    end
    add_index :queries, :task_id
  end
end
