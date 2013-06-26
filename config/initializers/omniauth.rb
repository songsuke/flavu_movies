OmniAuth.config.logger = Rails.logger
	Rails.application.config.middleware.use OmniAuth::Builder do
		provider :facebook, ENV['485755544834757'], ENV['47f821a4506ec42ffa6ab0eb1ba49880']
	end