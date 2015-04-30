require 'aws-sdk-v1'
require "refile/backend/s3"

aws = {
  access_key_id: Rails.application.secrets.s3_access_key_id,
  secret_access_key: Rails.application.secrets.s3_secret,
  bucket: Rails.application.secrets.s3_bucket,
}
Refile.cache = Refile::Backend::S3.new(prefix: "cache", **aws)
Refile.store = Refile::Backend::S3.new(prefix: "store", **aws)
