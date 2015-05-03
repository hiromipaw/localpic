module FileOperations

  def set_aws_bucket(bucket)
    AWS::S3.new(region: ENV['S3_REGION'], access_key_id: ENV['S3_ACCESS_KEY_ID'], secret_access_key: ENV['S3_SECRET']).buckets[bucket]
  end

  def get_file_from_aws(bucket, original_jpg_tmp_path, path, id)
    File.open(original_jpg_tmp_path, 'wb') do |file|
      bucket.objects[path].read do |chunk|
        file.write(chunk)
      end
    end
    logger.info "[id=#{id}] Finished downloading '#{path}' from '#{ENV['S3_BUCKET_DOWNLOAD']}'."
  end

  def s3_logging_error(id)
    logger.error "[id=#{id}] File not found at S3."
  end

  def delete_tmp_files(tmp_files, id)
    logger.debug "[id=#{id}] Starting deletion of tmp files for job."

    tmp_files.each do |path|
      logger.info "[id=#{id}] Deleting tmp file '#{path}'."
      if File.exist?(path)
        File.delete(path)
      end
    end

    logger.debug "[id=#{id}] Finished deleting tmp files for job."
  end

  def fetch_retry(retries, id)
    logger.info "[id=#{id}] Trying #{retries} more times to find file on S3"
  end

end
