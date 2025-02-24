# Disable SSL verification for Faraday globally
require 'faraday'
require 'rsolr'
require 'openssl'

# Disable OpenSSL peer verification globally
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.logger.warn "⚠️ SSL verification has been disabled globally."

# Set up Faraday to use the net_http adapter with SSL verification disabled
Faraday.default_connection = Faraday.new do |faraday|
  faraday.adapter :net_http
  faraday.ssl[:verify] = false
end

# Ensure rsolr uses the updated Faraday connection with SSL disabled
solr_url = Blacklight.connection_config[:url]  # Get Solr URL from Blacklight config

solr_config = { ssl: { verify: false } }
Blacklight.default_index = RSolr.connect(solr_url, solr_config)

Rails.logger.warn "⚠️ rsolr connection initialized with SSL verification disabled"
