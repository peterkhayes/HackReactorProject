'use strict';

# Controls the midi-js library.
class Tunesmith.Models.MidiModel extends Backbone.Model

  initialize: (cb) =>
    context = new window.AudioContext()

    instruments = {
      drum: {
        notes: [1, 2, 3, 4]
      }
      piano: {
        notes: [39, 44, 49, 54, 59, 64, 69, 74]
      }
    }

    # Load each instrument i in instruments.
    for i of instruments
      instruments[i].buffers = []
      for note, j in instruments[i].notes
        @loadBuffer("audio/#{i}/#{note}.mp3", instruments[i].buffers, j, context)

    @set 'instruments', instruments
    @set 'context', context
    @set 'noteEvents', []
    cb()

  loadBuffer: (url, destination, i, context) ->
    request = new XMLHttpRequest()
    request.open("GET", url, true)
    request.responseType = "arraybuffer"

    request.onload = () ->
      context.decodeAudioData(
        request.response,
        (buffer) ->
          if (!buffer)
            console.log "error decoding file data for #{url}"
            return
          destination[i] = buffer
        (error) ->
          console.error 'decodeAudioData error', error
      )

    request.onerror = () ->
      console.error "Could not fetch #{url} from the server."

    request.send()

  play: (type, note) ->
    type = 'piano'
    context = @get('context')

    # First we find the closest note that we have a sample for.
    instruments = @get 'instruments'
    notes = instruments[type].notes
    index = 0
    # Move forward until we are at or past the sample
    while notes[index] < note.pitch and index < notes.length - 1
      index++
    # See whether the sample above or the sample below is closer.
    if (notes[index] - note.pitch) > (note.pitch - notes[index-1]) then index--
    console.log "choosing pitch #{notes[index]}"

    # Make a source node with the correct audio.
    source = context.createBufferSource();
    source.buffer = instruments[type].buffers[index]
    # Pitch shift the playback and play!
    source.playbackRate.value = Math.pow(2,(note.pitch - notes[index])/12)
    source.gain.value = (note.vel / 127)
    source.connect(context.destination);
    source.noteOn(0)

    console.log source

    # Push the node into our events loop so we can end it later.
    @get('noteEvents').push({source: source, len: note.len})

  advance: ->
    events = @get 'noteEvents'
    stillActive = []
    for e in events
      if e.len
        e.len--
        stillActive.push(e)
      else
        @stopNote(e.source, e.gain)
    @set 'noteEvents', stillActive

  stopNote: (source) =>
    if source.gain.value == 0
      source.noteOff(0)
    else
      source.gain.value = Math.max(source.gain.value - 0.1, 0)
      setTimeout( =>
        @stopNote(source)
      ,1)

