'use strict';

class Tunesmith.Views.PlaybackBarView extends Backbone.View

  className: 'playbackBar clearfix'

  initialize: ->
    @model.on('advance', @render, @)
    @model.on('tick', @flash, @)
    @$el.append(Templates['playback_bar']);
    @playback_grad = $('.playbackGrad')
    console.log(@playback_grad)

  render: ->
    @playback_grad.css({width: @model.progress() + "%"});
    @$el

  flash: =>
    @playback_grad.addClass('flash');
    setTimeout(@unflash.bind(@), 100)

  unflash: =>
    @playback_grad.removeClass('flash');
