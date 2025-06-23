# frozen_string_literal: true

require "aws-sdk-s3"

Rails.application.config.to_prepare do
  # This is a hack to temporarily fix https://github.com/decidim/decidim/issues/14668
  Aws::S3::Presigner.class_eval do
    def presigned_url(method, params = {})
      params.delete(:host) if params.has_key?(:host)
      url, _headers = _presigned_request(method, params)
      url
    end
  end
end
