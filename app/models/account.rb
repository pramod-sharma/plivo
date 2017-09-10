class Account < ApplicationRecord
	self.table_name = "account"

	after_save :put_or_refresh_in_cache

	def self.reload_cache!
		Account.all.each do |account|
			account.put_or_refresh_in_cache
		end
	end

	def self.find_by_name(username)
		account = $plivo_redis.get("account##{ username }")
		if !account
			if account = Account.where(username: username).first
				account.put_or_refresh_in_cache
				account = account.attributes
			end
		else
			account = JSON.parse(account)
		end
		account
	end

	def put_or_refresh_in_cache
		$plivo_redis.set(redis_key, redis_value)
	end

	private
	def redis_key
		# Assumption is username will be unique
		"account##{ username }"	end

	def redis_value
		{ auth_id:  auth_id, username: username, id: id }.to_json
	end
end
