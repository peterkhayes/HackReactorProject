'use strict';

class Tunesmith.Models.MetronomeModel extends Backbone.Model

  initialize: (cb, context) ->
    @set 'context', context
    context.create
    cb()

  tick: (step) ->
