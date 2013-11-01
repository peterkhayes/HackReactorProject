'use strict';

class Tunesmith.Views.ClipView extends Backbone.View

  className: 'clip'

  initialize: ->
    @model.on('note', @flash, @)

  render: ->
    attrs = @model.attributes
    attrs.Type = attrs.type.charAt(0).toUpperCase() + attrs.type.slice(1);
    @$el.html(Templates['clip'](attrs))
    @$el

  flash: =>
    @$el.addClass('flash');
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');