class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :user
      t.string :text
      t.datetime :date
      t.string :tweet_id
      t.references :query

      t.timestamps
    end
    add_index :tweets, :query_id
  end
end
