'use strict';

class Tunesmith.Views.PlayerView extends Backbone.View

  className: "tab playback"

  initialize: (params) ->
    params = params || {}
    @collection = params.collection || null
    @tempo = params.tempo || 120
    @minInterval = params.minInterval || 8
    @currentTime = 0
    @maxTime = params.maxTime || 8*@minInterval

    @tick = new Audio("audio/tick.mp3")
    @tick.preload = 'auto'
    @tick.load()

    @tock = new Audio("audio/tock.mp3")
    @tock.preload = 'auto'
    @tock.load()

    @midi = params.midi


  events: ->
    'mousedown .tempo.up': => @startChangingTempo(1)
    'mousedown .tempo.down': => @startChangingTempo(-1)
    'mouseup .tempo': => @stopChangingTempo()
    'mouseout .tempo': => @stopChangingTempo()

  start: ->
    @collection.on('note', (e) => @midi.play(e.type, e.note))
    @advance()

  advance: =>
    @currentTime = (@currentTime + 1) % @maxTime
    @collection.play(@currentTime)
    @midi.advance()

    if (@currentTime % @minInterval) == 0
      @playSound(if @currentTime % (4 * @minInterval) then 'tick' else 'tock')

    setTimeout(@advance, 60000 / @tempo / @minInterval)

  playSound: (type) =>
    sound = this[type]
    console.log sound
    instance = sound.cloneNode().play()

  startChangingTempo: (amt) =>
    @tempo += amt
    @render()
    @tempoTimeout = setInterval( =>
      @tempo += amt
      @render()
    , 100)

  stopChangingTempo: =>
    clearInterval(@tempoTimeout)

  render: ->
    @$el.html(Templates['playback_tab']({tempo: @tempo}))
    @$el


