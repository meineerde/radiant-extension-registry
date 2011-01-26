class AddExtensionCountToAuthor < ActiveRecord::Migration
  class Author < ActiveRecord::Base
  end

  class Extension < ActiveRecord::Base
    def update_cached_fields
      Author.update_all(['extensions_count = ?', Extension.count(:id, :conditions => { :author_id => author_id })], ["id = ?", author_id])
    end
  end

  def self.up
    add_column :authors, :extensions_count, :integer, :default => 0
    Extension.find(:all).each &:update_cached_fields
  end

  def self.down
    remove_column :authors, :extensions_count
  end
end
