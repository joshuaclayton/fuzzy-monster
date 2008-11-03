class AddTopicCountToForums < ActiveRecord::Migration
  def self.up
    change_table :forums do |t|
      t.integer :topics_count, :default => 0
    end
  end

  def self.down
    change_table :forums do |t|
      t.remove :topics_count
    end
  end
end
