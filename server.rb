require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
 
# put your default Twilio Client name here, for when a phone number isn't given
default_client = "jenny"
# Add a Twilio phone number or number verified with Twilio as the caller ID
caller_id   = ENV['twilio_caller_id']
account_sid = ENV['twilio_account_sid']
auth_token  = ENV['twilio_account_token']
appsid      = ENV['hello_monkey_appid']

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
 

 
post '/voice' do
    number = params[:PhoneNumber]
    response = Twilio::TwiML::Response.new do |r|
        # Should be your Twilio Number or a verified Caller ID
        r.Dial :callerId => caller_id do |d|
            # Test to see if the PhoneNumber is a number, or a Client ID. In
            # this case, we detect a Client ID by the presence of non-numbers
            # in the PhoneNumber parameter.
            if /^[\d\+\-\(\) ]+$/.match(number)
                d.Number(CGI::escapeHTML number)
            else
                d.Client number
            end
        end
    end
    response.text
end