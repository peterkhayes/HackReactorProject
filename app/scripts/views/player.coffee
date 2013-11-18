'use strict';

class Tunesmith.Views.PlayerView extends Backbone.View

  className: "tab playback"

  initialize: (params) ->
    @listenTo(@collection, 'note', (e) =>
      @collection.tools('midi').play(e.type, e.note)
    )
    @interval = setInterval(@advance, 60000 / (@collection.params('tempo') * @collection.params('minInterval')))

  events: ->
    'mousedown .tempo.up': => @startChangingTempo(1)
    'mousedown .tempo.down': => @startChangingTempo(-1)
    'mouseup .tempo': => @stopChangingTempo()
    'mouseout .tempo': => @stopChangingTempo()

  advance: =>
    minInterval = @collection.params('minInterval')
    # Metronome
    if (@collection.params('currentTime') % minInterval) == 0
      step = (@collection.params('currentTime') % (4*minInterval))/4
      @tick(step == 0)

    if (@collection.params('currentTime') < 0) # Pre-recording.
      @collection.tools('midi').clear()
      @collection.params('currentTime', (@collection.params('currentTime') + 1))
      if @collection.params('currentTime') == -1
        setTimeout(@collection.record(), 60000 / (@collection.params('tempo') * minInterval))
    else # Regular mode.
      @collection.play(@collection.params('currentTime'))
      @collection.params('currentTime', (@collection.params('currentTime') + 1) % @collection.params('maxTime'))
      @collection.tools('midi').advance()


    # setTimeout(@advance, 60000 / (@collection.params('tempo') * minInterval))

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
    clearInterval(@interval)
    @interval = setInterval(@advance, 60000 / (@collection.params('tempo') * @collection.params('minInterval')))
    @collection.trigger('change')

  render: ->
    @$el.html(Templates['playback_tab']({tempo: @collection.params('tempo')}))
    @$el

  # Metronome.
  tick: (loud) ->
    @flash()
    if @collection.params('recordingDestination') then @collection.tools('midi').tick(loud)

  flash: ->
    @$el.addClass('flash')
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');


