Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, '***************', '****************', :scope => 'email', :display => 'touch', :secure_image_url=> true
  # If you want to also configure for additional login services, they would be configured here.
end