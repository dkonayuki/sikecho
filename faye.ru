#faye settings file for pub/sub system
#using thin as a sub-server handling pub/sub messages
require 'faye'
Faye::WebSocket.load_adapter('thin')
require File.expand_path('../config/app_environment_variables.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    if message['ext'] && message['ext']['auth_token']
      message['ext'] = {} 
    end
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 25)
faye_server.add_extension(ServerAuth.new)
run faye_server
