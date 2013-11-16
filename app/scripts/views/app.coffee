'use strict';

class Tunesmith.Views.AppView extends Backbone.View

  initialize: ->
    @playerView = new Tunesmith.Views.PlayerView({collection: @model.get('cliplist')})
    @clipsView = new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')})

    @menuBarView = new Tunesmith.Views.MenuBarView({model: @model})
    @authView = new Tunesmith.Views.LoginView({model: @model})
    @saveView = new Tunesmith.Views.SaveView({model: @model})
    @loadView = new Tunesmith.Views.LoadView({model: @model})

    @listenTo(@model, 'authSuccess', ->
      console.log @model.get('user')
      @menuBarView.render()
    )
    @listenTo(@model, 'clearSong', @resetClipViews)
    @render()

  events: ->
    'click header .newSong': ->
      @model.newSong()
    'click header .save': ->
      @saveView.render()
    'click header .load': ->
      @loadView.render()
    'click header .export': ->
      @model.export()
    'click header .login': ->
      @authView.render('login')
    'click header .signup': ->
      @authView.render('signup')
    'click header .logout': ->
      @model.logout()
      @menuBarView.render()

  render: ->
    @$el.html ''

    @$el.append(@playerView.render())
    @$el.append(@clipsView.render())
    @$el.append(@menuBarView.render())

    @$el

  resetClipViews: ->
    @playerView.remove()
    @playerView.unbind()
    clearInterval(@playerView.interval)
    @clipsView.remove()
    @clipsView.unbind()
    @playerView = new Tunesmith.Views.PlayerView({collection: @model.get('cliplist')})
    @clipsView = new Tunesmith.Views.ClipsView({collection: @model.get('cliplist')})

    @render()