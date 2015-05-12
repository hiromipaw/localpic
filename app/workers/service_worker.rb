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
      logger.info "[id=#{@id}] Starting download of '#{path}' from bucket '#{ENV['S3_BUCKET_DOWNLOAD']}'."
      bucket = set_aws_bucket(@s3_region, @s3_access_key_id, @s3_secret, @s3_bucket)
      original_jpg_tmp_path = "#{Rails.root}/tmp/filter_#{@id}_#{SecureRandom.uuid}.jpg"
      get_file_from_aws(bucket, original_jpg_tmp_path, path, @id)
      original_jpg_tmp_path

    end

    def upload(file, content_type, relative_path)
      logger.info "[id=#{@id}] Starting upload of '#{file}' to '#{relative_path}' and bucket '#{@s3_bucket}'."
      bucket = set_aws_bucket(@s3_bucket)
      s3_file = bucket.objects[relative_path]
      s3_file.write(file: file, acl: 'private', content_type: content_type, cache_control: 'max-age=315360000')
      logger.info "Finished uploading '#{file}' to '#{relative_path}' and bucket '#{@s3_bucket}'."

    end

  private

    def s3_error_skipping_callbacks
      logger.error "[id=#{@id}] Tried 3 times to find file in S3. Ending job, file not found at S3 (skipping callbacks)."
      @filter = Filter.find(clip_id: @id).first
      @filter.update(message: 'Server error', status: 500)
    end

    def setup_options_as_instance_variables(options)
      options.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def setup_aws_settings_as_instance_variables
      instance_variable_set(@s3_region, Rails.application.secrets.s3_region)
      instance_variable_set(@s3_access_key_id, Rails.application.secrets.s3_access_key_id)
      instance_variable_set(@s3_secret, Rails.application.secrets.s3_secret)
      instance_variable_set(@s3_bucket, Rails.application.secrets.s3_bucket)
    end


end
