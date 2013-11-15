'use strict';

class Tunesmith.Models.ClipModel extends Backbone.Model

  initialize: =>
    @set('name', @formatName(@get('type')))

  formatName: (str) ->
    str = (@capitalize(word) for word in str.split('_')).join(" ")

  capitalize: (str) ->
    str = (str.charAt(0).toUpperCase() + str.slice(1))

  play: (time) =>
    notes = @get('notes')
    if (notes and notes.length)
      note = notes[time % notes.length]
      if (note and note.pitch)
        @trigger('note', {type: @get('type'), note: note})

  clear: ->
    @set('notes', [])
