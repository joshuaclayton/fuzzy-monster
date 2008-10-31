%w(admin user).each do |group|
  Role.seed(:name) do |g|
    g.name = group
  end
end

%w(admin has_account).each do |privilege|
  Privilege.seed(:name) do |p|
    p.name = privilege
  end
end

admin = Role.find_by_name "admin"
user = Role.find_by_name "user"

priv_admin = Privilege.find_by_name "admin"
priv_has_account = Privilege.find_by_name "has_account"

[
  {:role => admin, :privilege => priv_admin}, 
  {:role => admin, :privilege => priv_has_account},
  {:role => user, :privilege => priv_has_account}
].each do |group_privilege|
  group_privilege[:role].privileges << group_privilege[:privilege]
end

User.seed(:email_address) do |a|
  a.email_address = "admin@example.com"
  a.password = "password"
  a.password_confirmation = "password"
  a.first_name = "Admin"
  a.last_name = "User"
  a.role = admin
  a.active = true
end