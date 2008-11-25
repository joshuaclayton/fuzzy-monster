module ForumsHelper
  def sortable_forums_recordset
    sortable_element("forums-tbody", :tag => "tr", :treeTag => "'tbody'", :ghosting => false, :url => reorder_forums_path, :method => :put)
  end
end