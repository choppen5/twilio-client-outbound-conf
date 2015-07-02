require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
 
# put your default Twilio Client name here, for when a phone number isn't given
default_client = "charles"
# Add a Twilio phone number or number verified with Twilio as the caller ID
caller_id   = ENV['twilio_caller_id']
account_sid = ENV['twilio_account_sid']
auth_token  = ENV['twilio_auth_token']
appsid      = ENV['twilio_app_id']

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
    erb :index, :locals => {:token => token, :client_name => client_name}
end
 

 
post '/agent-join-conf' do
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
    #do routing to find an agent, or use default
    #agentname = functiontofindavailibleagent
    agentname = default_client

    response = Twilio::TwiML::Response.new do |r|
        r.Dial do |d|
                d.Conference agentname, :beep => "onExit"
            end
    end
    puts response.text
    response.text
end

