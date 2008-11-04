module ApplicationHelper
  def breadcrumbs(options = {})
    topic = options.delete(:topic)
    forum = options.delete(:forum) || (topic ? topic.forum : nil)
    action = options.delete(:action)
    returning [] do |crumbs|
      crumbs << link_to_if(topic || forum, "Forums", forums_path)
      crumbs << link_to_unless(topic.nil?, forum.name, forum) if forum
      crumbs << link_to_unless(action.nil?, topic.title, [forum, topic]) if forum && topic
      crumbs << action
    end.compact
  end
end
