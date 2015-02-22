require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Skritter < OmniAuth::Strategies::OAuth2

      # Give your strategy a name.
      option :name, "skritter"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://www.skritter.com",
        :authorize_url => "/api/v0/oauth2/authorize",
        :token_url => "/api/v0/oauth2/token"
      }
  
      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ access_token.params['user_id'] }

      info do
        { :email => raw_info['email'] }
      end

      def raw_info
        @raw_info ||= { } 
      end

      protected
      # v1.1.2
      def build_access_token
  puts "build access token"
        params = {
          :redirect_uri => callback_url,
          :headers => { "Authorization" => "Basic " +
              Base64.strict_encode64("#{client.id}:#{client.secret}")
          },
          :code=>request.params['code'],
          :grant_type=>"authorization_code",
          :client_id=>client.id
        }.merge(token_params.to_hash(:symbolize_keys => true))
        client.auth_code.get_token(request.params['code'], params)
      end
    end
  end
end

