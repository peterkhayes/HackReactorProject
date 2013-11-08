'use strict';

class Tunesmith.Views.PlayerView extends Backbone.View

  className: "tab playback"

  initialize: (params) ->
    tick = new Audio("audio/tick.mp3")
    tick.preload = 'auto'
    tick.load()
    tock = new Audio("audio/tock.mp3")
    tock.preload = 'auto'
    tock.load()
    @sounds = {
      tick: tick
      tock: tock
    }

    @collection.on('note', (e) =>
      @collection.tools('midi').play(e.type, e.note)
    , @)
    @advance()

  events: ->
    'mousedown .tempo.up': => @startChangingTempo(1)
    'mousedown .tempo.down': => @startChangingTempo(-1)
    'mouseup .tempo': => @stopChangingTempo()
    'mouseout .tempo': => @stopChangingTempo()

  advance: =>
    currentTime = @collection.params('currentTime')
    @collection.params('currentTime', (currentTime + 1) % @collection.params('maxTime'))
    @collection.play(currentTime)
    @collection.tools('midi').advance()

    # if (@collection.params('currentTime') % @collection.params('minInterval')) == 0
    #   @playSound(if @collection.params('currentTime') % (4 * @collection.params('minInterval')) then 'tick' else 'tock')

    setTimeout(@advance, 60000 / @collection.params('tempo') / @collection.params('minInterval'))

  playSound: (type) =>
    @sounds[type].cloneNode().play()

  startChangingTempo: (amt) =>
    @collection.params('tempo', @collection.params('tempo') + amt)
    @render()
    @tempoTimeout = setInterval( =>
      @collection.params('tempo', @collection.params('tempo') + amt)
      @render()
    , 100)

  stopChangingTempo: =>
    clearInterval(@tempoTimeout)

  render: ->
    @$el.html(Templates['playback_tab']({tempo: @collection.params('tempo')}))
    @$el


