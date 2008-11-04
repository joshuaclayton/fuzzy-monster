class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.belongs_to :author, :topic, :forum
      t.text :body
      t.timestamps
    end
    
    [[:created_at, :forum_id], [:created_at, :topic_id], [:created_at, :author_id]].each do |column|
      add_index :posts, column
    end
  end

  def self.down
    drop_table :posts
  end
end
