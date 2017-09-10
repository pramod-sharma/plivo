class SmsController < ApplicationController
	skip_before_action :verify_authenticity_token
  around_action :catch_exceptions
  before_action :authenticate_account!
  # before_action :check_for_current_user!
	before_action :validate_inbound_params, only: :inbound
	before_action :log_stop_requests, only: :inbound, if: -> { params[:text].strip == "STOP" }
	before_action :validate_and_log_requests_count, only: :outbound
	before_action :validate_outbound_params, only: :outbound

	def inbound
		render json: { message: "inbound sms ok", error: "" }, status: 200 and return
	end

	def outbound
		render json: { message: "outbound sms ok", error: "" }, status: 200 and return
	end

  protected

  	def catch_exceptions
  		begin
      	yield
    	rescue => exception
        	render json: { message: "", error: "unknown failure" }, status: 200 and return
      end
    end

  	def validate_inbound_params
  		inbound_request = InboundRequest.new(params, @current_user)
  		if !inbound_request.valid?
  			render json: { message: "", error: inbound_request.errors.full_messages.first }, status: 200 and return
  		end
  	end

  	def log_stop_requests
  		$plivo_redis.setex("STOP##{ params[:from] }##{ params[:to] }", 4.hours, "")
  	end

  	def validate_outbound_params
  		inbound_request = OutboundRequest.new(params, @current_user)
  		if !inbound_request.valid?
  			render json: { message: "", error: inbound_request.errors.full_messages.first }, status: 200 and return
  		end
  	end

  	def validate_and_log_requests_count
  		if $plivo_redis.get(throttling_key(params['from'])) >= Constants.THROTTLING_LIMIT
  			render json: { message: "", error: "limit reached for from #{ self.from }" }, status: 200 and return
  		else
  		increment_throttling_counter	
  		end
  	end

  	def increment_throttling_counter
  		if $plivo_redis.incr(throttling_key(params['from'])) == 1
	    	$plivo_redis.expireat(throttling_key(params['from']), (Time.now + Constants.THROTTLING_TIME_LIMIT).to_i)
	  	end
	end

  	def throttling_key(from)
  		"#{ THROTTLE }##{ from }"
  	end

  	def authenticate_account!
      @current_user = nil

    	authenticate_or_request_with_http_basic do |username, password|
    		account = Account.find_by_name(username)
        @current_user = account
        render json: {}, status: 403 and return if (!account || account['auth_id'] != password)
    	end

      if !@current_user
        render json: {}, status: 403 and return
      end
  	end
end
