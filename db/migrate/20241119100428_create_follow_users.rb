class CreateFollowUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :follow_users do |t|
      t.integer :follower_id
      t.integer :followee_id

      t.timestamps
    end
    add_index :follow_users, :follower_id
    add_index :follow_users, :followee_id
    add_index :follow_users, %i[follower_id followee_id], unique: true
  end
end
