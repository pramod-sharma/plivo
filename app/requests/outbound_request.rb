class OutboundRequest
	include ActiveModel::Validations

	attr_accessor :from, :to, :text, :current_user

	validates :from, :to, :text, presence: { message: 'is missing' }

	validates :from, length: { minimum: 6, maximum: 16, too_short: 'is invalid', too_long: 'is invalid' }
	validates :to,   length: { minimum: 6, maximum: 16, too_short: 'is invalid', too_long: 'is invalid' }
	validates :text, length: { minimum: 1, maximum: 120, too_short: 'is invalid', too_long: 'is invalid' }

	validate :phone_in_users_list
	validate :number_not_in_stop_list


	def initialize(params, current_user)
		self.current_user = current_user
		@from = params[:from]
		@to   = params[:to]
		@text = params[:text]
	end

	private
	def number_not_in_stop_list
		if $plivo_redis.get("STOP##{ self.from }##{ self.to }")
			errors[:base] << "sms from #{ self.from } to #{ self.to } blocked by STOP request")
		end
	end

	def phone_in_users_list
		if !PhoneNumber.where(account_id: current_user["id"], number: self.from).exists?
			errors.add(:from, "parameter not found")
		end
	end
end