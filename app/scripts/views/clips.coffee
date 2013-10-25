'use strict';

class Tunesmith.Views.ClipsView extends Backbone.View

  className: 'clips clearfix'

  initialize: ->
    @collection.on('add change', @render, @)

  render: ->
    @$el.html ''
    @collection.each( (clip) =>
      @$el.append new Tunesmith.Views.ClipView({model: clip}).render
    )
    @$el
    
