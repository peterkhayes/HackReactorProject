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

  setupPlayer: ->
    @player.collection = @model.get 'cliplist'
    @player.midi = @model.get 'midi'
    @model.get('pitchDetector').set('player', @player)
    @player.start()

  render: ->
    @$el.html ''
    @$el.append(Templates["menu_bar"]())

    @player = new Tunesmith.Views.PlayerView()
    @setupPlayer()
    @$el.append(@player.render())

    @$el.append(new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')}).render())

    @$el

