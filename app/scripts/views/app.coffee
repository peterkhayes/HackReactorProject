'use strict';

class Tunesmith.Views.AppView extends Backbone.View

  initialize: ->
    console.log "intialized app view."
    @render()

  events: ->
    'click header .newSong': ->
      @model.newSong()
      @render()
    'click header .newSection': ->
      @model.newSection()
      @render()
    'click header .save': ->
      @model.save()
    'click header .load': ->
      @model.load('mySong')
      @render()
    'click header .export': ->
      @model.export()

  render: ->
    @$el.html ''
    @playerView = new Tunesmith.Views.PlayerView({collection: @model.get('cliplist')})
    @clipsView = new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')})
    @$el.append(Templates["menu_bar"]())

    @$el.append(@playerView.render())
    @$el.append(@clipsView.render())

    @$el

