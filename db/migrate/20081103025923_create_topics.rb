class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.belongs_to :forum, :creator
      t.string :title, :slug
      t.boolean :sticky, :default => false
      t.boolean :locked, :default => false
      t.integer :hits, :default => 0
      t.datetime :last_updated_at
      t.timestamps
    end
    
    add_index :topics, :slug, :uniq => true
    [:forum_id, :sticky, :hits, :creator_id, [:last_updated_at, :sticky], :last_updated_at].each do |column|
      add_index :topics, column
    end
  end

  def self.down
    drop_table :topics
  end
end
