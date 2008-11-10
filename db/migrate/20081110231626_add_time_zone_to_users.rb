class AddTimeZoneToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :time_zone
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :time_zone
    end
  end
end
