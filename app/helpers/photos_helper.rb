require 'rubygems'
require 'RMagick'

IMAGE_BASE=RAILS_ROOT + "/public/uploaded/"
DVDD_BASE=RAILS_ROOT + "/tmp/divideds/"

module PhotosHelper

  def get_image_bin(path)
    img = Magick::Image.from_blob(File.read(path)).shift
    img.to_blob
  end

  def get_thumbnail_bin(t_path)
    img = Magick::Image.from_blob(File.read(t_path)).shift
    img.to_blob
  end

  def create_with_thumbnail(binary)
    path = IMAGE_BASE + Time.now.to_i.to_s

    File.open(path, 'wb') do |outfile|
      outfile.write(binary.read)
    end
    img = Magick::Image.from_blob(File.read(path)).shift
    t_path = path + "_t"
    thumbnail = img.thumbnail(0.1)
    File.open(t_path, 'wb') do |outfile|
      outfile.write(thumbnail.to_blob)
    end
    [path, t_path]
  end

  def divide_image(path, id)
    image = Magick::Image.from_blob(File.read(path)).first.resize(300, 300)
    height = image.rows
    width = image.columns
    path = "#{DVDD_BASE}#{id}_#{Time.now.to_i}"
    divided = Dir.glob("#{DVDD_BASE}#{id}_*")
    if divided.empty?
      [[0, 0, width/2, height/2],[width/2, 0, width/2, height/2], [0, height/2, width/2, height/2], [width/2, height/2, width/2, height/2]].each_with_index do |arr, idx|
        cropped = image.crop(arr[0], arr[1], arr[2], arr[3])
        File.open("#{path}_#{idx}", 'wb') do |outfile|
          outfile.write(cropped.to_blob)
        end
        divided.push("#{path}_#{idx}")
      end
    else
      divided = divided.map {|v| File.expand_path(v)}
    end
    divided.sort_by{rand}
  end
end
