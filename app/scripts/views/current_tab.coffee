'use strict';

class Tunesmith.Views.CurrentTabView extends Backbone.View

  className: 'current tab'


  render: (state) ->
    state = state || "Displaying all clips"
    @$el.html(Templates['current_tab']({state: state}))
    @$el