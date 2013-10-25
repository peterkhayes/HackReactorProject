'use strict';

class Tunesmith.Views.AppView extends Backbone.View

  initialize: ->
    @model = new Tunesmith.Models.AppModel()
    @render()

  render: ->
    @$el.append(new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')}).render())
    @$el

