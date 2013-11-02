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

  play: (channel, note) ->
    console.log "playing a note on channel #{channel}"
    console.log note
    noteEvents = @get 'noteEvents'
    MIDI.noteOn(channel, note.pitch, note.vel)
    noteEvents.push({channel: channel, note:note})

  advance: ->
    noteEvents = @get 'noteEvents'
    stillActive = []
    for e, i in noteEvents
      if e.note.len
        e.note.len--
        stillActive.push(e)
      else
        MIDI.noteOff(e.channel, e.note.pitch)
    @set 'noteEvents', stillActive

window.p = (num) ->
  MIDI.noteOn(1, num, 127)