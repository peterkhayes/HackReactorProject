'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    this.set 'cliplist', new Tunesmith.Collections.ClipCollection()

