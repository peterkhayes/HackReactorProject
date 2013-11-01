'use strict';

class Tunesmith.Collections.ClipCollection extends Backbone.Collection
  
  model: Tunesmith.Models.ClipModel

  play: (time) ->
    @each( (clip) =>
      clip.play(time)
    )


