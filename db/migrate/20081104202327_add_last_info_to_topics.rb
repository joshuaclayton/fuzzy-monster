class AddLastInfoToTopics < ActiveRecord::Migration
  def self.up
    change_table :topics do |t|
      t.belongs_to :last_post, :last_user
    end
  end

  def self.down
    change_table :topics do |t|
      t.remove :last_post_id, :last_user_id
    end
  end
end
