# frozen_string_literal: true

class EnableCDNURLSigningValidator
  def initialize(opts = {})
    @opts = opts
  end

  def valid_value?(val)
    return true if val == 'f'
    return false if !SiteSetting.secure_media?
    return false if SiteSetting.cdn_signed_urls_key.blank? or SiteSetting.cdn_signed_urls_key_name.blank?
    true
  end

  def error_message
    if !SiteSetting.secure_media?
      I18n.t('gcloud_cdn_signer.errors.no_secure_media')
    end

    if SiteSetting.cdn_signed_urls_key.blank?
      I18n.t('gcloud_cdn_signer.errors.missing_signing_key')
    end

    if SiteSetting.cdn_signed_urls_key_name.blank?
      I18n.t('gcloud_cdn_signer.errors.missing_key_name')
    end
  end
end
