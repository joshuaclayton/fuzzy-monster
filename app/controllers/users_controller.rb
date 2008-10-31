class UsersController < ApplicationController
  acts_as_login_controller :allow_signup => true, :login_flash => nil

  redirect_after_login do
    root_path
  end
end
