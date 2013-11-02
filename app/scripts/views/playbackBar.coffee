'use strict';

class Tunesmith.Views.PlaybackBarView extends Backbone.View

  className: 'playbackBar clearfix'

  initialize: ->
    @model.on('tick', @flash, @)
    @$el.append(Templates['playback_bar'])
    @playback_grad = $('.playbackGrad')
    @render

  render: ->
    @$el

  flash: =>
    @playback_grad.addClass('flash')
    setTimeout(@unflash.bind(@), 100)

  unflash: =>
    @playback_grad.removeClass('flash')
