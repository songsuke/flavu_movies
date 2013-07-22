class IpGetController < ApplicationController
require 'address'
	def getip
		@ip = Address.get
	end
end
