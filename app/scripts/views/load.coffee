'use strict';

class Tunesmith.Views.LoadView extends Backbone.View

  className: 'popup load'

  events: {
    'click button.close': 'close'
    'click .song': 'load'
  }

  render: ->
    $('#greyout').show()
    user = @model.get('user')
    @$el.html(Templates['load']({user: user, loading: true}))
    if (user)
      @model.getSongList( (songs) =>
        @$el.html(Templates['load']({user: user, songs: songs}))
      )
    @$el.appendTo('body')

  close: ->
    @$el.detach()
    $('#greyout').hide()

  load: (e) ->
    console.log "Loading {$(e.target).text()}"
    @model.load($(e.target).text(), @model.newSong)
    @close()

  error: (err) ->
    @$el.find('.error').text(err)
