'use strict';

class Tunesmith.Views.AppView extends Backbone.View

  initialize: ->
    console.log "intialized app view."
    @model = new Tunesmith.Models.AppModel()
    @render()

  events: ->
    'click header .newSong': 'initialize'
    'click header .newSection': ->
      @model.newSection()
      @render()
    'click header .save': ->
      @model.save()
    'click header .load': ->
      @model.load()
    'click header .export': ->
      @model.export()

  render: ->
    @$el.html ''
    @$el.append(Templates["playback_grad"])
    @$el.append(Templates["menu_bar"]())
    @$el.append(new Tunesmith.Views.PlaybackBarView({model: @model}).render())
    @$el.append(new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')}).render())
    @$el

