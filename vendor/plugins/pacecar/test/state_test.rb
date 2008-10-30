require File.join(File.dirname(__FILE__), 'test_helper')

class StateTest < Test::Unit::TestCase

  context "A class which has included Pacecar" do
    setup do
      @class = Post
    end
    should "set the correct proxy options for a column_state _state method" do
      assert @class.respond_to?(:publication_state_draft)
      proxy_options = { :conditions => ['"posts".publication_state = ?', 'Draft'] }
      assert_equal proxy_options, @class.publication_state_draft.proxy_options
    end
    should "set the correct proxy options for a column_not_state _state method" do
      assert @class.respond_to?(:publication_state_not_draft)
      proxy_options = { :conditions => ['"posts".publication_state <> ?', 'Draft'] }
      assert_equal proxy_options, @class.publication_state_not_draft.proxy_options
    end
    should "set the correct proxy options for a column_state _type method" do
      assert @class.respond_to?(:post_type_postmodern)
      proxy_options = { :conditions => ['"posts".post_type = ?', 'PostModern'] }
      assert_equal proxy_options, @class.post_type_postmodern.proxy_options
    end
    should "set the correct proxy options for a column_not_state _type method" do
      assert @class.respond_to?(:post_type_not_postmodern)
      proxy_options = { :conditions => ['"posts".post_type <> ?', 'PostModern'] }
      assert_equal proxy_options, @class.post_type_not_postmodern.proxy_options
    end
  end

end
