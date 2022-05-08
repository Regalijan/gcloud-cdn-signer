# frozen_string_literal: true

# name: gcloud-cdn-signer
# about: Plugin to create signed CDN URLs for Google Cloud
# version: 0.2
# author: Wolftallemo
# url: https://github.com/Wolftallemo/gcloud-cdn-signer

require 'openssl'
require 'base64'
require_dependency 'file_store/s3_store'
require_relative 'lib/validators/enable_cdn_signing_validator.rb'
require_relative 'lib/validators/reset_cdn_signing_creds_validator.rb'

enabled_site_setting :cdn_signed_urls_enabled

after_initialize do
  module DiscourseCDNSignedURLs
    def presigned_get_url(
      url,
      force_download: false,
      filename: false,
      expires_in: SiteSetting.cdn_signature_expiration_time
    )

      if !SiteSetting.cdn_signed_urls_enabled? or SiteSetting.s3_cdn_url.blank?
        return super
      end

      if force_download && filename
        opts = {
          expires_in: S3Helper::DOWNLOAD_URL_EXPIRES_AFTER_SECONDS,
          response_content_disposition: ActionDispatch::Http::ContentDisposition.format(
            disposition: "attachment", filename: filename
          )
        }
        obj = object_from_path(url)
        return obj.presigned_url(:get, opts)
      end

      signing_key = Base64.urlsafe_decode64 SiteSetting.cdn_signed_urls_key
      unsigned_url = "#{SiteSetting.s3_cdn_url}/#{url}?Expires=#{Time.now.to_i + expires_in}&KeyName=#{SiteSetting.cdn_signed_urls_key_name}"
      sig = OpenSSL::HMAC.digest "SHA1", signing_key, unsigned_url
      encoded_sig = Base64.urlsafe_encode64 sig
      "#{unsigned_url}&Signature=#{encoded_sig}"
    end
  end

  class FileStore::S3Store
    prepend DiscourseCDNSignedURLs
  end
end
