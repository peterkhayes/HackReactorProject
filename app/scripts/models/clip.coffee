'use strict';

class Tunesmith.Models.ClipModel extends Backbone.Model

  initialize: =>

  clear: ->
    @set 'notes', []

  record: ->
    console.log('triggering record')
    @trigger 'record', @

  play: (time) =>
    notes = @get('notes')
    if (notes and notes.length)
      note = notes[time % notes.length]
      if (note and note.pitch)
        @trigger('note', {type: @get('type'), note: note})
