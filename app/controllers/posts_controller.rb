class PostsController < ApplicationController
  resource_controller
  belongs_to :topics
end
