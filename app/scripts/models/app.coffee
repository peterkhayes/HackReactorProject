'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    cliplist = new Tunesmith.Collections.ClipCollection()
    cliplist.on('record', @record, @)
    cliplist.on('stopRecordingAndAddClip', @stopRecordingAndAddClip, @)
    @set 'cliplist', cliplist
    @set 'recordingDestination', null

  record: (clip) ->
    console.log 'recording'
    console.log @get('recorder')
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
      notes = pitchDetector.convertToNotes(buffer) # Process the notes - NOTE: BLOCKING.
      clip.set 'notes', notes # Give the notes to the clip.
      if (notes.length / minInterval) > @get('maxTime') then @set('maxTime', notes.length / minInterval)
      @set 'recordingDestination', null # We are no longer recording to a clip.
      recorder.clear() # Empty the recorder to save memory.
      cliplist.finishedRecording() # Trigger an event to update the view.
    )

  save: (title) ->
    cliplist = @get 'cliplist'
    data = {
      tempo: @get 'tempo'
      clips: []
    }
    cliplist.each( (clip) ->
      data.clips.push({
        notes: clip.get('notes'),
        type: clip.get('type')
      })
    )
    console.log data
    # $.post({
    #   url: "songs/#{title}"
    #   data: data
    # })

  load: (title) ->
    toLoad = Tunesmith.songs[title]
    cliplist = new Tunesmith.Collections.ClipCollection()
    for clip in toLoad.clips
      cliplist.add(new Tunesmith.Models.ClipModel({type: clip.type, notes: clip.notes}))
    @set('cliplist', cliplist)
    @set('tempo', toLoad.tempo)

