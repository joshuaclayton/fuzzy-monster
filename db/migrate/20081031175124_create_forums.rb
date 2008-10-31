class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :name, :slug
      t.text :description
      t.integer :position, :default => 1
    end
    add_index :forums, :position
    add_index :forums, :slug, :uniq => true
  end

  def self.down
    drop_table :forums
  end
end
