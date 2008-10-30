class AddMhsAuthenticationSystem < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
    end
    add_index :roles, :name, :uniq => true
    
    create_table :privileges do |t|
      t.string :name
    end
    add_index :privileges, :name, :uniq => true

    create_table :privileges_roles, :id => false do |t|
      t.integer :role_id
      t.integer :privilege_id
    end
    add_index :privileges_roles, :role_id
    add_index :privileges_roles, :privilege_id

    create_table :users do |t|
      t.string :password_hash
      t.string :salt
      t.string :email_address
      t.integer :role_id
      t.boolean :active
      t.string :remember_me_token
      t.datetime :remember_me_token_expires_at
      t.string :first_name, :last_name, :username
    end
    
    [:role_id, :active].each do |column|
      add_index :users, column
    end
    add_index :users, :email_address, :uniq => true
    add_index :users, :username, :uniq => true
    
    create_table :user_reminders do |t|
      t.integer :user_id
      t.string :token
      t.datetime :expires_at
    end
    add_index :user_reminders, [:user_id, :token, :expires_at]
  end

  def self.down
    drop_table :users
    drop_table :privileges_roles
    drop_table :privileges
    drop_table :roles
    drop_table :user_reminders
  end
end
