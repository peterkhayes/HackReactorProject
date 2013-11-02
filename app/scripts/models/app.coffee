'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    cliplist = new Tunesmith.Collections.ClipCollection()
    cliplist.on('note', @playNote, @)
    cliplist.on('record', @record, @)
    cliplist.on('stopRecordingAndAddClip', @stopRecordingAndAddClip, @)

    @set 'cliplist', cliplist
    @set 'minInterval', 8
    @set 'tempo', 120
    @set 'maxTime', 8*@get('minInterval')
    @set 'currentTime', 0
    @set 'recordingDestination', null

    @metronome = setInterval(@advance, 60000 / @get('tempo') / @get('minInterval'))
    console.log @get('midi'), @get('recorder'), @get('pitchDetector')

  advance: =>
    @set('currentTime', (@get('currentTime') + 1) % @get('maxTime'))
    @get('cliplist').play(@get('currentTime'))
    @get('midi').advance()

    @trigger('advance')
    if ((@get('currentTime') % @get('minInterval')) == 0)
      @trigger('tick')

  # Returns a percent.
  progress: =>
    @get('currentTime')*100/@get('maxTime')

  playNote: (e) =>
    @get('midi').play(e.channel, e.note)

  record: (clip) ->
    @set 'currentTime', 0
    @set 'recordingDestination', clip
    @get('recorder').record()

  stopRecordingAndAddClip: ->
    console.log 'Stopping recording, adding clip'
    clip = @get 'recordingDestination'
    recorder = @get 'recorder'
    pitchDetector = @get 'pitchDetector'
    cliplist = @get 'cliplist'
    minInterval = @get 'minInterval'

    recorder.stop()
    recorder.getBuffer( (buffer) => # Get the recorded buffer from the recorder.
      notes = pitchDetector.convertToNotes(buffer, @get('tempo'), @get('minInterval')) # Process the notes - NOTE: BLOCKING.
      clip.set 'notes', notes # Give the notes to the clip.
      cliplist.add(clip) # Add the clip to the list.
      if (notes.length / minInterval) > @get('maxTime') then @set('maxTime', notes.length / minInterval)
      @set 'recordingDestination', null # We are no longer recording to a clip.
      recorder.clear() # Empty the recorder to save memory.
      cliplist.endRecording() # Trigger an event to update the view.
    )



