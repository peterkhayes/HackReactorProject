'use strict';

class Tunesmith.Views.ClipView extends Backbone.View

  events: {
    'mouseup': 'edit'
  }

  initialize: ->
    @listenTo(@model, 'note', @flash)

  render: ->
    @$el = $(Templates['selector']({
      name: @model.get('name'),
      image: @model.get('type')
    }))
    @delegateEvents()
    @$el.addClass('clip')
    @$el

  flash: =>
    @$el.addClass('flash');
    setTimeout(@unflash.bind(@), 50)

  unflash: =>
    @$el.removeClass('flash');

  edit: =>
    @model.trigger('edit', @model)
