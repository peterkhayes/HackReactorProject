'use strict';

class Tunesmith.Views.PlaybackTabView extends Backbone.View

  className: 'playback tab'

  render: ->
    @$el.html(Templates['playback_tab']())
    @$el