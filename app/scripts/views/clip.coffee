'use strict';

class Tunesmith.Views.ClipView extends Backbone.View

  tagName: 'button'

  className: 'clip'

  initialize: ->
    @model.on('note', @flash, @)

  events: ->
    'click': -> @model.trigger('showOptions', @model)

  render: ->
    attrs = @model.attributes
    attrs.Type = @capitalizeFirst(attrs.type)
    @$el.html(Templates['clip'](attrs))
    @$el

  flash: =>
    @$el.addClass('flash');
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');

  capitalizeFirst: (str) ->
    return str.charAt(0).toUpperCase() + str.slice(1)
