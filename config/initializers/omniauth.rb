Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :bnet, ENV['BNET_KEY'], ENV['BNET_SECRET'], scope: 'wow.profile'
end

# Use the rails logger
OmniAuth.config.logger = Rails.logger
