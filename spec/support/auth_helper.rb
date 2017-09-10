module AuthHelper
  def http_login(username, password)
  	@env ||= {}
    user = username
    pw = password
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end  
end