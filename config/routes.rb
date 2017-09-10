Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/inbound/sms/', to: 'sms#inbound'
  get '/inbound/sms/', to: proc { [405, {}, ['']] }
  patch '/inbound/sms/', to: proc { [405, {}, ['']] }
  put '/inbound/sms/', to: proc { [405, {}, ['']] }
  delete '/inbound/sms/', to: proc { [405, {}, ['']] }


  post '/outbound/sms/', to: 'sms#outbound'
  get '/outbound/sms/', to: proc { [405, {}, ['']] }
  patch '/outbound/sms/', to: proc { [405, {}, ['']] }
  put '/outbound/sms/', to: proc { [405, {}, ['']] }
  delete '/outbound/sms/', to: proc { [405, {}, ['']] } 
end
