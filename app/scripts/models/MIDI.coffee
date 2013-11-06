'use strict';

# Controls the midi-js library.
class Tunesmith.Models.MidiModel extends Backbone.Model

  initialize: (cb) =>
    MIDI.loadPlugin({
      instruments: ["acoustic_grand_piano", "synth_drum"],
      callback: =>
        MIDI.programChange(0, 0);
        MIDI.programChange(1, 118);
        console.log "midi plugin loaded!"
        cb()
    })
    @set 'noteEvents', []
    @set('channels', {
      Instrument: 0
      Drum: 1
    })

  play: (type, note) ->
    #console.log note
    noteEvents = @get 'noteEvents'
    channel = @get('channels')[type]
    MIDI.noteOn(channel, note.pitch, note.vel)
    noteEvents.push({channel: channel, pitch: note.pitch, len: note.len})

  advance: ->
    noteEvents = @get 'noteEvents'
    stillActive = []
    for e in noteEvents
      if e.len
        e.len--
        stillActive.push(e)
      else
        MIDI.noteOff(e.channel, e.pitch)
    @set 'noteEvents', stillActive

  typeToChannel: (type) ->
    return [type]

# Useful for testing midi events.
# window.p = (channel, num) ->
#   MIDI.noteOn(channel, num, 127)