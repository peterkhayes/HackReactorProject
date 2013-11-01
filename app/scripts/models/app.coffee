'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    cliplist = new Tunesmith.Collections.ClipCollection()
    cliplist.on('note', @playNote, @)

    @set 'cliplist', cliplist
    @set 'minInterval', 16
    @set 'tempo', 120
    @set 'maxTime', 8*@get('minInterval')
    @set 'currentTime', 0

    midi = new Tunesmith.Models.MidiModel()
    @set 'midi', midi

    @metronome = setInterval(@advance, 60000 / @get('tempo') / @get('minInterval'))

  advance: =>
    @set('currentTime', (@get('currentTime') + 1) % @get('maxTime'))
    @get('cliplist').play(@get('currentTime'))
    @get('midi').advance()

    @trigger('advance')
    if ((@get('currentTime') % @get('minInterval')) == 0)
      @trigger('tick')

  # Returns a percent.
  progress: =>
    @get('currentTime')*100/@get('maxTime')

  playNote: (note) =>
    @get('midi').play(0, note)