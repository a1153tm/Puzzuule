class AddThumbnailToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :thumbnail, :string
  end

  def self.down
    remove_column :photos, :thumbnail
  end
end
