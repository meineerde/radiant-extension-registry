class PaginatedDataset < Dataset::Base
  uses :authors, :plugins
  
  def load
    (1..100).each do |number|
      create_plugin("plugin_#{number}",
        :name => "Plugin #{number}",
        :author_id => author_id(:seancribbs, :aaron, :jlong, :saturnflyer).rand,
        :description => "This plugin's number #{number}"
      )
    end
    (1..35).each do |number|
      author = create_author("thing_#{number}", :name => "Thing #{number}")
      create_plugin("plugin_#{(1 * number) + 100}",
        :name => "Plugin #{(1 * number) + 100}",
        :author_id => author.id,
        :description => "This plugin's number #{(1 * number) + 100}"
      )
    end
  end
end