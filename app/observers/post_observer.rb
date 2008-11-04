class PostObserver < ActiveRecord::Observer
  def after_create(post)
    topic = post.topic
    topic.send(:attributes=, {:last_post => post, :last_user => post.author, :last_updated_at => post.created_at}, false)
    topic.save!
  end
end
