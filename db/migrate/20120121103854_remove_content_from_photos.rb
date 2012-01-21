class RemoveContentFromPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :content
  end

  def self.down
  end
end
