'use strict';

class Tunesmith.Collections.ClipCollection extends Backbone.Collection

  model: Tunesmith.Models.ClipModel

  initialize: ->
    @_tools = {}
    @_params = {
      tempo: 120
      minInterval: 8
      currentTime: 0
      maxTime: 64
      recordingDestination: null
    }

    @on('record', @record)
    console.log @

  tools: (name, value) ->
    if value?
      @_tools[name] = value
    else
      @_tools[name]

  params: (name, value) ->
    if value?
      @_params[name] = value
    else
      @_params[name]

  play: (time) ->
    @each( (clip) =>
      clip.play(time)
    )

  record: (clip) ->
    console.log 'Recording'
    @_params.currentTime = 0
    @_params.recordingDestination = clip
    @_tools.recorder.record()

  stopRecordingAndAddClip: ->
    console.log 'Stopping recording, adding clip'

    @_tools.recorder.stop()
    @_tools.recorder.getBuffer( (buffer) => # Get the recorded buffer from the recorder.
      notes = @_tools.pitchDetector.convertToNotes(buffer, @_params.tempo, @_params.minInterval) # Process the notes - NOTE: BLOCKING.
      @_params.recordingDestination.set 'notes', notes # Give the notes to the clip.
      if (notes.length / @_params.minInterval) > @_params.maxTime then @_params.maxTime = notes.length / minInterval
      @_params.recordingDestination = null # We are no longer recording to a clip.
      @_tools.recorder.clear() # Empty the recorder to save memory.
      @trigger 'finishedRecording' # Trigger an event to update the view.
    )