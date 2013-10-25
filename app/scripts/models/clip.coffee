'use strict';

class Tunesmith.Models.ClipModel extends Backbone.Model

  click: ->
    type = @.get 'type'
    if type is 'addnew'
      @trigger 'addnew'

  changeTo: (type) ->
    if (type == 'cancel')
      @trigger 'cancel', @