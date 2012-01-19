class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :name
      t.binary :content, :limit => (16*1024*1024 - 1)

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
