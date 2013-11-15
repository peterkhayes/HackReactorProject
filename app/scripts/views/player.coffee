'use strict';

class Tunesmith.Views.PlayerView extends Backbone.View

  className: "tab playback"

  initialize: (params) ->
    @listenTo(@collection, 'note', (e) =>
      @collection.tools('midi').play(e.type, e.note)
    )
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

    if (@collection.params('currentTime') % @collection.params('minInterval')) == 0
      step = (@collection.params('currentTime') % (4*@collection.params('minInterval')))/4
      @tick()

    @collection.tools('midi').advance()
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

  tick: ->
    console.log('tick')
    @flash()

  flash: ->
    @$el.addClass('flash')
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');


