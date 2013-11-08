'use strict';

class Tunesmith.Views.ClipView extends Backbone.View

  initialize: ->
    @model.on('note', @flash, @)

  events: ->
    'click': -> @model.trigger('showOptions', @model)

  render: ->
    @$el.html(Templates['selector']({
      name: @capitalizeFirst(@model.get('type'))
      type: clip
      image: @model.get('type')
    })
    @$el

  flash: =>
    @$el.addClass('flash');
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');

  capitalizeFirst: (str) ->
    return str.charAt(0).toUpperCase() + str.slice(1)
