class PhotosController < ApplicationController
  def index
    logger.debug(params)
  end
  def upload
    logger.debug(params)
  end
end
