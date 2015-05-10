module FiltersOperations
  extend ActiveSupport::Concern

  def build_filter_params(params)
      %w(id,type,size).each do |key|
        params.require(key)
      end
      params
  end

  def create_filter(params)
    filter = Filter.create(filter_id: params[:id],
                           message: 'Accepted',
                           location: "filters/#{params[:id]}",
                           code: 202, status: 202)
    if filter
      filter.serialize
    else
      filter_error
    end
  end

  def filter_error
    {
      response: {
        message: 'Internal Server Error',
        code: 500
      },
      status: 500
    }
  end

  def filter_not_found
    {
      response: {
        message: 'Not Found',
        code: 404
      },
      status: 404
    }
  end
end
