'use strict';

class Tunesmith.Models.ClipModel extends Backbone.Model

  initialize: =>
    notes = []
    for i in [0..31]
      if (Math.random() < 0.3)
        notes[4*i] = {
          pitch: Math.floor(Math.random()*12) + 60
          vel: Math.floor(Math.random()*64) + 50
          len: Math.floor(Math.random()*4) + 1
        }
    @set 'notes', notes


  play: (time) =>
    notes = @get('notes')
    if (notes and notes.length)
      note = notes[time % notes.length]
      if (note)
        @trigger('note', note)
