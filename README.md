# Google Cloud CDN URL Signer

## What is it?
This plugin overrides the `presigned_get_url` method of `FileStore::S3Store` to generate a signed Google Cloud CDN link (instead of a storage bucket link). It is intended to be used in conjunction with secure media.

## How to use
This section assumes you have already set up [Google Cloud CDN with signed URLs](https://cloud.google.com/cdn/docs/using-signed-urls) and that [secure uploads](https://meta.discourse.org/t/secure-media-uploads/140017) is enabled.

Prerequisites:
- [Google Cloud CDN with signed URLs](https://cloud.google.com/cdn/docs/using-signed-urls) is configured.
- [Secure Uploads](https://meta.discourse.org/t/secure-uploads/140017) is enabled.
- Your S3 CDN URL is set.

Steps:
1. Install using the normal plugin installation steps.
2. Set your key name and signing key.
3. Tick the cdn_signed_urls_enabled setting.
