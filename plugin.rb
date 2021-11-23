# frozen_string_literal: true

# name: gcloud-cdn-signer
# about: Plugin to create signed CDN URLs for Google Cloud
# version: 0.1
# author: Wolftallemo
# url: https://github.com/Wolftallemo/gcloud-cdn-signer

require 'openssl'
require 'base64'
require_dependency 'file_store/s3_store'
require_dependency 's3_helper'
require_relative 'lib/validators/enable_cdn_signing_validator.rb'
require_relative 'lib/validators/reset_cdn_signing_creds_validator.rb'

enabled_site_setting :cdn_signed_urls_enabled
enabled_site_setting :secure_media

after_initialize do
  if SiteSetting.cdn_signed_urls_enabled? && SiteSetting.secure_media? && !SiteSetting.s3_cdn_url.blank?
    module DiscourseCDNSignedURLs    
      def presigned_get_url(url)
        signing_key = Base64.urlsafe_decode64 SiteSetting.cdn_signed_urls_key
        unsigned_url = "#{SiteSetting.s3_cdn_url}/#{url}?Expires=#{Time.now.to_i + SiteSetting.cdn_signature_expiration_time}&KeyName=#{SiteSetting.cdn_signed_urls_key_name}"
        sig = OpenSSL::HMAC.digest "SHA1", signing_key, unsigned_url
        encoded_sig = Base64.urlsafe_encode64 sig
        "#{unsigned_url}&Signature=#{encoded_sig}"
      end
    end

    class FileStore::S3Store
      prepend DiscourseCDNSignedURLs
    end
  end
end
