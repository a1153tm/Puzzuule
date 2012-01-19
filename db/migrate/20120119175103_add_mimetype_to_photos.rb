class AddMimetypeToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :mimetype, :string
  end

  def self.down
    remove_column :photos, :mimetype
  end
end
