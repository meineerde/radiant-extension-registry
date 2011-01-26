class RenameExtensionToPlugin < ActiveRecord::Migration
  def self.up
    remove_index :extensions, :name => 'extensions_search'
    rename_table :extensions, :plugins
    add_index :plugins, ['name', 'description'], :name => "plugins_search"
    
    rename_column :dependencies, :extension_id, :plugin_id
    
    rename_column :authors, :extensions_count, :plugins_count
  end
  
  def self.down
    remove_index :plugins, :name => 'plugins_search'
    rename_table :plugins, :extensions
    add_index :extensions, ['name', 'description'], :name => "extensions_search"
    
    rename_column :dependencies, :plugin_id, :extension_id
    
    rename_column :authors, :plugins_count, :extensions_count
  end
end