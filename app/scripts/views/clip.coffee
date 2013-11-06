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
    @$el.html(Templates['clip'](attrs))
    @$el

  flash: =>
    @$el.addClass('flash');
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');