'use strict'

# Controls the recorder-js model.
class Tunesmith.Models.RecorderModel extends Backbone.Model

  initialize: (cb, context) ->

    navigator.getUserMedia({audio: true},
      (stream) => # Successfully connected to microphone.
        input = context.createMediaStreamSource(stream)

        @set 'recorder', new Recorder(input)
        cb()
      ,
      (e) => # Failed to connect to microphone.
        console.log "No live audio input: #{e}"
    )

  getBuffer: (cb) ->
    @get('recorder').getBuffer(cb)

  record: ->
    @get('recorder').record()

  stop: ->
    @get('recorder').stop()

  clear: ->
    @get('recorder').clear()