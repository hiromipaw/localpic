require 'ohm'
require 'ohm/contrib'

class Filter < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Versioned
  include Ohm::Timestamps

  attribute :filter_id
  attribute :message
  attribute :location
  attribute :status
  attribute :code
  index :filter_id


  def serialize
    {
      filter: { id: filter_id, location: location },
      response: { message: message, code: code.to_i },
      status: status.to_i
    }
  end
end
