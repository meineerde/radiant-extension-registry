class HomeController < ApplicationController
  def index
    @plugins = Plugins.find(:all, :order => "created_at DESC", :limit => 4)
    
    author_ids = Author.find(:all, :conditions => ["plugins_count > 0"], :select => :id).collect(&:id)
    @authors = Author.find(:all, :conditions => {:id => author_ids.sort_by{rand}[0..5] })
  end
end