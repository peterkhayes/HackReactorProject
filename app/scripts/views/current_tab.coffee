'use strict';

class Tunesmith.Views.CurrentTabView extends Backbone.View

  className: 'current tab'

  render: ->
    @$el.html(Templates['current_tab']({current: @model.currentAction}))
    @$el