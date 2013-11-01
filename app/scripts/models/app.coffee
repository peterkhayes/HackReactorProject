'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    cliplist = new Tunesmith.Collections.ClipCollection()
    cliplist.on('note', @playNote, @)
    this.set 'cliplist', cliplist
    this.set 'minInterval', 16
    this.set 'tempo', 120
    this.set 'maxTime', 8*@get('minInterval')
    this.set 'currentTime', 0

    @metronome = setInterval(@advance, 60000 / @get('tempo') / @get('minInterval'))

  advance: =>
    @set('currentTime', (@get('currentTime') + 1) % @get('maxTime'))
    
    @get('cliplist').play(@get('currentTime'))

    @trigger('advance')
    if ((@get('currentTime') % @get('minInterval')) == 0)
      @trigger('tick')

  # Returns a percent.
  progress: =>
    @get('currentTime')*100/@get('maxTime')

  playNote: (note) =>