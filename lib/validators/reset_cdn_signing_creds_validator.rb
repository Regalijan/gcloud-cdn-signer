# frozen_string_literal: true

class ResetSignedCDNURLsCreds
  def initialize(opts = {})
    @opts = opts
  end

  def valid_value?(val)
    return true if !SiteSetting.cdn_signed_urls_enabled?
    return false if val.blank?

    true
  end

  def error_message
    I18n.t('gcloud_cdn_signer.errors.cannot_disable')
  end
end
