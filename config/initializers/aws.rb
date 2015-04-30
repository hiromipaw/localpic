require 'aws-sdk'

Aws.config[:stub_responses] = true if Rails.env.test?
Aws.config[:credentials] = Aws::Credentials.new(
                              Rails.application.secrets.s3_access_key_id,
                              Rails.application.secrets.s3_secret)
Aws.config[:region] = Rails.application.secrets.s3_region
Aws.config[:log_level] = Rails.logger.level
Aws.config[:logger] = Rails.logger
