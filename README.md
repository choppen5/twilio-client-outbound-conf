#Twilio Client quicker-starter.

The source code and tutorial for the full system comes from the excellent Twilio Quickstart guide here: <https://www.twilio.com/docs/quickstart/ruby/client> .  This is a great way to get a browser call going - you can use this app to make calls from the browser - to any browser or any phone number.

If you follow that tutorial (which I highly encourage you to do so), you will have a full understanding of how to make phone calls from your browser, using the Twilio javascript client.  You will need to follow all the steps to have a local development environment, and walk through creating a Twilio client in the language of your choice (in this example Ruby).

But, if  you are feeling lazy, or in a hurry, you can use this source code to simply deploy to Heroku using the lovely [Heroku Button](https://blog.heroku.com/archives/2014/8/7/heroku-button). 

## Quicker Install ##


### Prerequisites 
1.  A Heroku account. Go sign up now, it's free (to start): www.heroku.com
2.  A Twilio account. Go sign up now, it's free (to start): www.twilio.com

### Twilio steps

You will need these after pressing the Deploy to Heroku button, so we will prepare by getting these values:

- Log into your Twilio account, note the following items,
	- Your Twilio Account Sid
	- Your Twilio Auth Token
	- A Twilio Phone Number 
	- Now, the hard one. Creating a new Twilio App.  In your Twilio account, navigate here
	  - Account > Dev Tools > Twiml Apps.  
	  - Press the "Create Twiml App" button.  Give your App a Friendly Name, such as "Hello Monkey". We will fill out the Voice URL later, after pressing the Heroku button.  
		- After creating the Twiml App, note the App Sid (need to click on the name of the Twiml App to see the Application Sid).

### Heroku steps

Now, you are ready to fearlessly Press the Heroku button. This will ask for some variables (see above), create a new Heroku app, and deploy this source code to Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy) 

You will be asked for a few parameters, all of which you have in hand from the previous steps.


### BAM! In the Cloud! 

You have a new Heroku app, it's live, in the cloud, and free as long as it's running on one dyno.  

It should work to render the HTML, but you will be missing some functionality, such as being able to Dial an external number.

![TwilioClient](http://uploadir.com/u/udmp7g31 "Twilio Client")



Say the Heroku URL created was:

	http://funky-monkey-567.herokuapp.com. 

You will take that URL and go back into your Twilio account, and set update a few things
	 
### Post Heroku button Twilio steps

Take your new Heroku URL (for example http://funky-monkey-567.herokuapp.com) and update the following things in your Twilio account:

* Twilio App Voice Request URL: http://funky-monkey-567.herokuapp.com/voice. This is the action that will be called when a user presses the Dial button on the webpage.  

![TwimlApp](http://uploadir.com/u/ee82e4sm "TwimlApp")


## BLAM BLAM!  

Your Sir, or should I say Madam, have a Twilio softphone running in the browser. 

Note.. anybody who knows this URL can just come to this page and start making calls.. which will charge your Twilio Account. So don't go tweeting about it, unless you want to subsidize such behavior.











