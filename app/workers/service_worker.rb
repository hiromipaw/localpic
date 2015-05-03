require 'rubygems'
require 'celluloid'

class ServiceWorker
  include Sidekiq::Worker
  include Celluloid
  include FileOperations

  class RequestError < StandardError; end
  class BadRequestError < RequestError; end
  class UnknownRequestError < RequestError; end

  protected

    def download(path)

    end

    def upload(file, content_type, relative_path)

    end

  private

    def setup_options_as_instance_variables(options)
      options.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end


end
