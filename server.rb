require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'logger'
require 'pusher'
require 'em-http-request'


logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

 
# put your default Twilio Client name here, for when a phone number isn't given
default_client = "charles"
# Add a Twilio phone number or number verified with Twilio as the caller ID
caller_id   = ENV['twilio_caller_id']
account_sid = ENV['twilio_account_sid']
auth_token  = ENV['twilio_auth_token']
appsid      = ENV['twilio_app_id_outbound']

pusher_key      = ENV['pusher_key']
pusher_secret   = ENV['pusher_secret']
pusher_appid    = ENV['pusher_appid']

Pusher.url = "http://#{pusher_key}:#{pusher_secret}@api.pusherapp.com/apps/#{pusher_appid}"



get '/' do
    client_name = params[:client]
    if client_name.nil?
        client_name = default_client
    end

    capability = Twilio::Util::Capability.new account_sid, auth_token
    # Create an application sid at twilio.com/user/account/apps and use it here
    capability.allow_client_outgoing appsid
    capability.allow_client_incoming client_name
    token = capability.generate
    erb :index, :locals => {:token => token, :client_name => client_name, :pusher_key => pusher_key}
end
 

 
post '/agent-join-conf' do
    logger.debug("agent-join-conf request #{params}")
    agentname = params[:agentname] || default_client #:agentname passed from the agent connection
    response = Twilio::TwiML::Response.new do |r|
        r.Say "Please wait for the first customer call.", :voice => "alice"
        r.Dial do |d|
                d.Conference agentname, :beep => "onExit"
        end
    end
    puts response.text
    response.text
end

post '/customer-join-conf' do
    logger.debug("customer-join-conf request #{params}")
    #do routing to find an agent, or use default
    #agentname = functiontofindavailibleagent
    agentname = default_client
    Pusher[default_client].trigger_async('outbound_call', {
        message: "Customer Call! You are connected to #{params['To']}"
    })

    logger.debug("sent pusher message, generating Twiml")

    response = Twilio::TwiML::Response.new do |r|
        r.Dial(:action => '/after-customer-call') do |d|
                d.Conference agentname, :beep => "onExit"
            end
    end
    logger.debug(response.text)
    response.text
end

post '/make-dial-request' do
    dialto = params[:dialnumber] #passed from the client (or more likely a auto dialer manager server component)
    client = Twilio::REST::Client.new account_sid, auth_token

    client.account.calls.create({
          :from => caller_id,
          :to => dialto,
          :url => "#{request.base_url}/customer-join-conf"
        })

    return ""
end 

post '/after-customer-call' do
    logger.debug("after customer call #{params}")

    Pusher[default_client].trigger('outbound_call', {
        message: "Customer Call complete!"
    })

    return ""
end 

