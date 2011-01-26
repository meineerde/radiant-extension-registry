atom_feed do |feed|
  feed.title("ChiliProject Plugin Registry")
  feed.updated((@plugins.first.created_at))
  for plugin in @plugins
    feed.entry(plugin) do |entry|
      entry.title(plugin.name)
      entry.summary(:type => :xhtml) do |summary|
        xml.text!(sanitize(textilize(plugin.description)))
      end
      entry.author do |author|
        author.name(plugin.author.name_or_login)
      end
    end
  end
end
