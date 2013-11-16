'use strict';

class Tunesmith.Collections.ClipCollection extends Backbone.Collection

  model: Tunesmith.Models.ClipModel

  initialize: ->
    @_params = {
      tempo: 120
      minInterval: 4
      currentTime: 0
      maxTime: 32
      recordingDestination: null
    }
    @_tools = {}

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

  prerecord: (clip) ->
    console.log "Preparing for recording, clip is #{clip}"
    @_tools.midi.loadInstrument(clip.get('type'))
    @_tools.midi.clear()
    @_params.currentTime = -4*@_params.minInterval
    @_params.recordingDestination = clip

  record: ->
    console.log 'Recording'
    @trigger('record')
    @_tools.recorder.record()

  stopRecordingAndAddClip: ->
    clip = @_params.recordingDestination
    console.log 'Stopping recording, adding clip #{clip}'

    @_tools.recorder.stop()
    @_tools.recorder.getBuffer( (buffer) => # Get the recorded buffer from the recorder.
      # Process the notes - NOTE: BLOCKING.
      if clip.get('type').slice(-4) == "_kit" # All drums end in _kit.
        notes = @_tools.pitchDetector.convertToDrums(buffer, @_params.tempo, @_params.minInterval)
      else # Non-drum instruments.
        notes = @_tools.pitchDetector.convertToNotes(buffer, @_params.tempo, @_params.minInterval)
      clip.set 'notes', notes # Give the notes to the clip.
      if (notes.length) > @_params.maxTime then @_params.maxTime = notes.length
      @_params.recordingDestination = null # We are no longer recording to a clip.
      @_tools.recorder.clear() # Empty the recorder to save memory.
      @trigger 'finishedRecording' # Trigger an event to update the view.
    )