'use strict';

class Tunesmith.Models.ClipModel extends Backbone.Model

  initialize: =>
    @set 'channel', @typeToChannel()
    notes = []
    if (@get('type') == 'drum')
      for i in [0..31]
        rand = Math.random()
        if rand < 0.1
          pitch = 61
        else if rand < 0.2
          pitch = 60
        else if rand < 0.4
          pitch = 59
        else pitch = 0
        unless pitch == 0
          notes[8*i] = {
            pitch: pitch
            vel: Math.floor(Math.random()*64) + 50
            len: 1
          }
    else
      for i in [0..31]
        if (Math.random() < 0.3)
          notes[8*i] = {
            pitch: Math.floor(Math.random()*24) + 36
            vel: Math.floor(Math.random()*64) + 50
            len: Math.floor(Math.random()*4) + 1
          }
    @set 'notes', notes

  record: ->
    @trigger 'record', @

  play: (time) =>
    notes = @get('notes')
    if (notes and notes.length)
      note = notes[time % notes.length]
      if (note)
        @trigger('note', {channel: @get('channel'), note: note})

  typeToChannel: ->
    type = @get 'type'
    return {
      instrument: 0
      drum: 1
    }[type]
