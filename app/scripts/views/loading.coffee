'use strict';

class Tunesmith.Views.LoadingView extends Backbone.View

  render: (loaded, total) ->
    @$el.html ''
    @$el.append(Templates["loading"]({loaded: loaded, total: total}))
    @$el
