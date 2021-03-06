
class PhotosController < ApplicationController

  include PhotosHelper

  # GET /photos
  # GET /photos.xml
  def index
#    @photos = Photo.all
    @photos = Photo.find(:all, :select => 'id, name, thumbnail')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
     @photo = Photo.find_by_sql ["SELECT id, name FROM photos WHERE id = ?", params[:id]]
#    @photo = Photo.select("id, name").where(params[:id])
#    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    paths = create_with_thumbnail(params['content'])
    @photo = Photo.create(:name => params['photo']['name'], :mimetype => params['content'].content_type, :path => paths[0], :thumbnail => paths[1])
    @photo.save()

    respond_to do |format|
      if @photo.save
        format.html { redirect_to(@photo, :notice => 'Photo was successfully created.') }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
        format.json { render :json => {'p_url' => "#{PUZZUULE_URL_BASE}id=#{@photo.id}"} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to(@photo, :notice => 'Photo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end

  def get_thumbnail
    @photo = Photo.where(:id => params[:id]).first
    binary = get_thumbnail_bin(@photo.thumbnail)
    send_data(binary, :disposition => "inline", :type => @photo.mimetype)
  end

  def get_image
    @photo = Photo.where(:id => params[:id]).first
    binary = get_image_bin(@photo.path)
    send_data(binary, :disposition => "inline", :type => @photo.mimetype)
  end

  def get_image_by_path
    @photo = Photo.where(:id => params[:id]).first
    binary = get_image_bin(params[:path])
    send_data(binary, :disposition => "inline", :type => @photo.mimetype)
  end

  def puzzuule
    photo = Photo.where(:id => params[:id]).first
    @divided = divide_image(photo.path, params[:id])
    @id = params[:id]
  end
end
