'use strict';

class Tunesmith.Models.MidiModel extends Backbone.Model

  initialize: =>
    MIDI.loadPlugin({
      instrument: "acoustic_grand_piano"
      callback: =>
        console.log "midi plugin loaded!"
    })
    @set 'noteEvents', []

  play: (channel, note) ->
    console.log "playing a note"
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