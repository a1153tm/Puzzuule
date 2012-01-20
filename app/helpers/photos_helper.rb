require 'rubygems'
require 'RMagick'

module PhotosHelper
  def divide_image(id)
    photo = Photo.find(id)
    #image = Magick::Image.ping(<path_to_file>).first
    height = image.rows
    width = image.columns
    divided = []
    [[0, 0, width/2, height/2],[width/2, 0, width/2, height/2], [0, height/2, width/2, height/2], [width/2, height/2, width/2, height/2]].each do |x, y, xx, yy|
      divided.push(image.crop(x, y, xx, yy))
    end
    divided
  end
end
