'use strict';

class Tunesmith.Views.LoadingView extends Backbone.View

  render: (loaded) ->
    @$el.html ''
    @$el.append(Templates["loading"]({loaded: loaded}))
    @$el
