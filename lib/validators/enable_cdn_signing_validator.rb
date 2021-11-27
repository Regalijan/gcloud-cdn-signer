# frozen_string_literal: true

class EnableCDNURLSigningValidator
  def initialize(opts = {})
    @opts = opts
  end

  def valid_value?(val)
    return true if val == 'f'
    return false if SiteSetting.cdn_signed_urls_key.blank? or SiteSetting.cdn_signed_urls_key_name.blank?
    true
  end

  def error_message
    I18n.t('gcloud_cdn_signer.errors.missing_settings')
  end
end
