class Constants
	if Rails.env.development?
		THROTTLING_LIMIT = 50
		THROTTLING_TIME_LIMIT = 24.hours
	elsif Rails.env.test?
		THROTTLING_LIMIT = 3
		THROTTLING_TIME_LIMIT = 30.seconds
	end
end


