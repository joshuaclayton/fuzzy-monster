class AddCounterCaches < ActiveRecord::Migration
  def self.up
    change_table :topics do |t|
      t.integer :posts_count, :default => 0
    end
    
    change_table :forums do |t|
      t.integer :posts_count, :default => 0
    end
    
    change_table :users do |t|
      t.integer :posts_count, :default => 0
    end
  end

  def self.down
    change_table :topics do |t|
      t.remove :posts_count
    end
    
    change_table :forums do |t|
      t.remove :posts_count
    end
    
    change_table :users do |t|
      t.remove :posts_count
    end
  end
end
