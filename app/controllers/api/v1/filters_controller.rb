class Api::V1::FiltersController < ApplicationController
  include FiltersOperations

  def index
    @filters = Filter.all.to_a
    if @filters
      render json: @filters, status: 200
    else
      render json: filter_not_found, status: 404
    end

  end

  # Public: Resource endpoint for filters
  #
  # GET /filters/:id
  #
  # id      - id of the filter to be represented [mandatory]
  #
  # Examples
  #   GET /filters/:id
  #   params:
  # => {
  #     "filter":
  #       {
  #         "id":"127",
  #         "location":"filters/127"
  #       },
  #     "response":
  #     {
  #       "message":"See Other",
  #       "code":"303"
  #     },
  #     "status":"303"
  #   }
  # Return the filter representation
  def show
    @filter = Filter.find(filter_id: params[:id]).first
    if @filter
      render json: @filter.serialize, status: @filter.serialize[:status]
    else
      render json: filter_not_found, status: 404
    end
  end

  # Public: Resource endpoint for filters
  #
  # POST /filters
  #
  #
  # Examples
  #   POST /filters
  #   params:
  # => {
  #     "filter":
  #       {
  #         "id":"127",
  #         "location":"filters/127"
  #       },
  #     "response":
  #     {
  #       "head":"Accepted",
  #       "code":"202"
  #     },
  #     "status":"202"
  #     "location": "filters/127"
  #   }
  # Return the status message, code and location
  def create
    if ImageFilter.perform_async(build_filter_params(params))
      @filter = create_filter(params)
      render json: @filter, status: @filter[:status]
    else
      render json: filter_error, status: 500
    end

  end

  # Public: Resource endpoint for filters
  #
  # DELETE /filters/1
  #
  #
  # Examples
  #   DELETE /filters/1
  #   params:
  # => {
  #     "filter":
  #       {
  #         "image_id":"1",
  #       },
  #     "response":
  #     {
  #       "message":"",
  #       "code":"204"
  #     },
  #     "status":"204"
  #   }
  # Return head no content
  def delete

  end

end
