'use strict';

class Tunesmith.Views.AppView extends Backbone.View

  initialize: ->
    console.log "intialized app view."
    @render()

  events: ->
    'click header .newSong': ->
      @model.initialize()
      @render()
    'click header .newSection': ->
      @model.newSection()
      @render()
    'click header .save': ->
      @model.save()
      @render()
    'click header .load': ->
      @model.load('mySong')
      @render()
    'click header .export': ->
      @model.export()
      @render()

  render: ->
    @$el.html ''
    @$el.append(Templates["menu_bar"]())

    @$el.append(new Tunesmith.Views.CurrentTabView({model: @model}).render())

    playerView = new Tunesmith.Views.PlayerView({
      collection: @model.get 'cliplist'
      midi: @model.get 'midi'
    })
    @model.get('pitchDetector').set('player', playerView)
    @$el.append(playerView.render())

    @$el.append(new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')}).render())

    @$el

