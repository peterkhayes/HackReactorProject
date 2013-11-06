'use strict';

class Tunesmith.Views.PlayerView extends Backbone.View

  className: "tab playback"

  initialize: (params) ->
    console.log params
    @collection = params.collection
    @tempo = params.tempo || 120
    @minInterval = params.minInterval || 8
    @currentTime = 0
    @maxTime = params.maxTime || 8*@minInterval

    @midi = params.midi
    @collection.on('note', (e) => @midi.play(e.type, e.note))

    @metronome = setInterval(@advance, 60000 / @tempo / @minInterval)

  advance: =>
    @currentTime = (@currentTime + 1) % @maxTime
    @collection.play(@currentTime)
    @midi.advance()

    if (@currentTime % @minInterval) == 0
      @tick()

  tick: ->

  render: ->
    @$el.html(Templates['playback_tab']({tempo: @tempo}))
    @$el


