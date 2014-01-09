Tunesmith
=========

[Try it out here!](http://tunesmith.azurewebsites.net/ "Tunesmith")  But only in Chrome on a desktop.

Record songs with only your voice - no instruments required!

Tunesmith is a web application that uses your voice as a substitute for instruments.  You can sing or beatbox into your microphone, and the app will convert the sounds into the instrument of your choice.  

How to use
==========
* Click the big yellow button to add tracks.
* Chose what type of track you want to use: instruments, drums, or live vocals (currently in development)
* Select the instrument you'd like to use.
* Sing!
* Wait for it...
* Layer more tracks for more tunage.
* Change the tempo with the arrows around the BPM indicator.
* Make an account to save and load songs.
* Export your tune to mp3 or midi (currently in development)

Tech
=======
<strong>Language</strong>: Coffeescript  
<strong>MVC</strong>: Backbone.js  
<strong>Persistence</strong>: Firebase (an awesome solution for serverless databases: sync your data real time to the cloud)  
<strong>Authentication</strong>: Firebase Simple Login  
<strong>CSS</strong>: Stylus  
<strong>Templating</strong>: Handlebars  
<strong>Pitch Detection</strong>: My own [pitchfinder.js](https://github.com/peterkhayes/pitchfinder.js "pitchfinder.js")  
<strong>Playback</strong>: My other baby [instrumental.js](https://github.com/peterkhayes/instrumental.js "instrumental.js")

Many thanks to
==============
* Matt Diamond (https://github.com/mattdiamond/), for Recorder.js
* Jens Nockert (https://github.com/JensNockert/), for his FFT algorithm
* Joren Six (https://github.com/JorenSix/), whose TarsosDSP package contained code for the YIN pitch detection algorithm that I ported to Javascript. 
* The excellent team at Firebase, for their awesome tech support.
* HACK REACTOR, the best place in the world to become a web developing superhero.
