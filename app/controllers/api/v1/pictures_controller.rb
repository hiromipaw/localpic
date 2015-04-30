class Api::V1::PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :update, :destroy]


  # GET /pictures.json
  def index
    @pictures = Picture.all
    if @pictures
      render json: @pictures,
             each_serializer: PictureSerializer,
             root: "pictures"
    else
      @error = Error.new(text: "404 Not found",
                         status: 404,
                         url: request.url,
                         method: request.method)
      render json: @error.serializer
    end
  end


  # GET /pictures/1.json
  def show
    if @picture
      render json: @picture,
             serializer: PictureSerializer,
             root: "picture"
    else
      @error = Error.new(text: "404 Not found",
                         status: 404,
                         url: request.url,
                         method: request.method)
      render json: @error.serializer
    end
  end


  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)

    if @picture.save
      render json: @picture,
                   serializer: PictureSerializer,
                   meta: { status: 201,
                           message: "201 Created",
                           location: @picture
                   },
                   root: "picture"

    else
      @error = Error.new(text: "500 Server Error",
                         status: 500,
                         url: request.url,
                         method: request.method)
      render :json => @error.serializer
    end
  end


  # PATCH/PUT /pictures/1.json
  def update
    if @picture.update(picture_params)
      render json: @picture, serializer: PictureSerializer,
                   meta: {
                     status: 200,
                     message: "200 OK",
                     location: @picture
                   },
                   root: "picture"

    else
      @error = Error.new(text: "500 Server Error",
                         status: 500,
                         url: request.url,
                         method: request.method)
      render :json => @error.serializer
    end
  end


  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    render json: { head: :no_content }
  end


  private


    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:title, :image)
    end
end
