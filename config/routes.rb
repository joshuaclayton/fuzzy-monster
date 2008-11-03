ActionController::Routing::Routes.draw do |map|
  map.resources :forums do |forums_map|
    forums_map.resources :topics
  end

  map.root :controller => "home"
  
  # Lightweight Auth routes
  map.with_options :controller => "users" do |users_map|
    users_map.login           "login",    :action => "login"
    users_map.signup          "signup",    :action => "signup"
    users_map.reminder_login  "users/:id/login/:token", :action => "login"
    users_map.logout          "logout",   :action => "logout"
    users_map.reminder        "users/reminder", :action => "reminder"
    users_map.profile         "profile",  :action => "profile"
  end
end
