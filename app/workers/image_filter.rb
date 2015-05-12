class ImageFilter < ServiceWorker
  include ImageOperations

  sidekiq_options queue: :low

  sidekiq_options retry: 5
  sidekiq_retry_in { 3.minutes }

  sidekiq_retries_exhausted do |msg|
    logger.error "[worker][filter] Failed #{msg['class']} with #{msg['args']}:
                  #{msg['error_message']}"
  end

  def perform(options)
    setup_options_as_instance_variables(options)
    logger.info "[id=#{@id}] FilterImages work started."
    process_filter
    perform_callbacks("filters/#{@id}")
  end

  private
    def process_filter
      MiniMagick::Tool::Convert.new do |builder|
        builder << @image
        builder << "-sepia-tone 80%"
        builder << @image
      end

    end

end
