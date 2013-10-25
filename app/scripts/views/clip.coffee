'use strict';

class Tunesmith.Views.ClipView extends Backbone.View

  className: 'clip'

  initialize: ->
    @model.on('cancel', @remove, @)

  events:
    'click': ->
      @model.click()
    'click .action': (e) ->
      @model.changeTo $(e.target).attr('action')

  render: =>
    type = @model.get 'type'
    @$el.addClass type

    template = Templates['clip_' + type]    
    @$el.html(template())
    return @$el

  remove: ->
    @$el.remove()

