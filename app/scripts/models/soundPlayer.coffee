'use strict';

class Tunesmith.Models.SoundPlayerModel extends Backbone.Model

  initialize: (cb, context) =>

    sounds = {
      metronome: {
        buffers: []
      }
      hiphop_kit: {
        notes: [1, 2, 3]
      }
      live_kit: {
        notes:[1, 2, 3]
      }
      dance_kit: {
        notes: [1, 2, 3]
      }
      piano: {
        notes: [39, 44, 49, 54, 59, 64, 69, 74]
      }
      e_guitar: {
        notes: [44, 49, 54, 59, 64, 69, 74]
      }
      a_guitar: {
        notes: [44, 49, 54, 59, 64, 69, 74]
      }
      bass: {
        notes: [62, 57, 52, 47, 42]
      }
      synth: {
        notes: [44, 49, 54, 59, 64, 69, 74]
      }
      sax: {
        notes: []
      }
      strings: {
        notes: [44, 49, 54, 59, 64, 69, 74]
      }
    }

    @set 'sounds', sounds
    @set 'context', context
    @set 'noteEvents', []

    @loadBuffer("audio/metronome/tick.mp3", sounds.metronome.buffers, 0)

    cb()



  # Load an instrument in the background.
  loadInstrument: (name) ->
    console.log "attempting to load #{name}"
    instrument = @get('sounds')[name]
    unless instrument.buffers
      instrument.buffers = []
      for note, i in instrument.notes
          @loadBuffer("/audio/#{name}/#{note}.mp3", instrument.buffers, i)
          # @loadBuffer("https://s3-us-west-1.amazonaws.com/tunesmith/audio/#{name}/#{note}.mp3", instrument.buffers, i)

  loadBuffer: (url, destination, i) ->
    request = new XMLHttpRequest()
    request.open("GET", url, true)
    request.responseType = "arraybuffer"

    request.onload = () =>
      @get('context').decodeAudioData(
        request.response,
        (buffer) ->
          if (!buffer)
            console.log "error decoding file data for #{url}"
            return
          console.log "Downloaded #{url}"
          if i?
            destination[i] = buffer
          else
            destination = buffer
        (error) ->
          console.error 'decodeAudioData error', error
      )

    request.onerror = () ->
      console.error "Could not fetch #{url} from the server."

    request.send()

  play: (type, note) ->
    context = @get('context')

    # First we find the closest note that we have a sample for.
    sounds = @get 'sounds'
    notes = sounds[type].notes
    index = 0
    # Move forward until we are at or past the sample
    while notes[index] < note.pitch and index < notes.length - 1
      index++
    # See whether the sample above or the sample below is closer.
    if (notes[index] - note.pitch) > (note.pitch - notes[index-1]) then index--

    # Make a source node with the correct audio.
    source = context.createBufferSource()
    unless (sounds[type].buffers and sounds[type].buffers[index])
      console.log "instrument not loaded yet"
      return
    source.buffer = sounds[type].buffers[index]
    # Pitch shift the playback and play!
    source.playbackRate.value = Math.pow(2,(note.pitch - notes[index])/12)
    source.gain.value = (note.vel / 127)
    source.connect(context.destination)
    source.noteOn(0)

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
        @stopNote(e.source)
    @set 'noteEvents', stillActive

  stopNote: (source) =>
    if source.gain.value == 0
      source.noteOff(0)
    else
      source.gain.value = Math.max(source.gain.value - 0.1, 0)
      setTimeout( =>
        @stopNote(source)
      ,1)

  clear: ->
    for e in @get('noteEvents')
      @stopNote(e.source)

  tick: (loud) ->
    context = @get('context')

    source = context.createBufferSource()
    source.buffer = @get('sounds').metronome.buffers[0]
    source.connect(context.destination)
    if loud then source.gain.value = 2
    source.noteOn(0)