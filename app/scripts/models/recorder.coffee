'use strict'

# Controls the recorder-js model.
class Tunesmith.Models.RecorderModel extends Backbone.Model

  initialize: (cb) ->
    try 
      #webkit shim
      window.AudioContext = window.AudioContext or window.webkitAudioContext
      navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia
      window.URL = window.URL or window.webkitURL
      audio_context = new AudioContext
      console.log 'Audio context set up.'
      console.log "navigator.getUserMedia #{if navigator.getUserMedia then 'available.' else 'not present!'}"
    catch e
      alert 'No web audio support in this browser!'

    navigator.getUserMedia({audio: true},
      (stream) => # Successfully connected to microphone.
        input = audio_context.createMediaStreamSource(stream)
        console.log 'Media stream created.'

        @set 'recorder', new Recorder(input)
        console.log 'Recorder initialised.'
        cb()
      ,
      (e) => # Failed to connect to microphone.
        console.log "No live audio input: #{e}"
    )

  command: (c) ->
    args = Array.prototype.slice.call(@, 1)
    recorder = @get('recorder')
    if (typeof recorder[c] == "function")
      recorder[c].apply(@, args)
    else
      throw "Recorder does not have a function named #{c}"