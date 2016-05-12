require 'sinatra' 
require 'oauth2' 

CLIENT_ID = CLIENT_ID_HERE
CLIENT_SECRET = CLIENT_SECRET_HERE
REDIRECT_URI = REDIRECT_URI_HERE

def client
  OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
    :site => 'https://jawbone.com/',
    :authorize_url => '/auth/oauth2/auth/',
    :token_url => '/auth/oauth2/token'
  )
end

get '/' do 
  params = { 
    :scope => 'basic_read', 
    :redirect_uri => REDIRECT_URI
  } 
  redirect client.auth_code.authorize_url(params) 
end 

get '/auth' do 
  code = params[:code]
  token = client.auth_code.get_token(code, 
    :redirect_uri => 'http://127.0.0.1:9393/auth',
    :headers => {'Authorization' => 'Bearer'})
    
  user = token.get('https://jawbone.com/nudge/api/v.1.1/users/@me/').body 
end