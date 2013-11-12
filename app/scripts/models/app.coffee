'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    cliplist = new Tunesmith.Collections.ClipCollection()
    cliplist.tools('midi', @get('midi'))
    cliplist.tools('recorder', @get('recorder'))
    cliplist.tools('pitchDetector', @get('pitchDetector'))
    cliplist.tools('metronome', @get('metronome'))
    @set('cliplist', cliplist)

    @set('auth', new FirebaseSimpleLogin(
      new Firebase('https://tunesmith.firebaseio.com/'), (error, user) =>
        window.CurrentUser = => console.log(@get('user'))
        if error
          console.log(error)
          @trigger('authError', error)
        else if user
          console.log(user)
          @set 'user', user
          @trigger('authSuccess')
        else
          console.log("Not Logged In")
          @set 'user', null
      )
    )

  newSong: ->
    @get('cliplist').resetParams()
    @get('cliplist').reset()

  login: (email, pass) =>
    console.log("attempting to log in...")
    @get('auth').login('password', {
        email: email
        password: pass
      })

  signup: (email, pass) ->
    console.log("attempting to sign up...")
    @get('auth').createUser(email, pass, (error, user) ->
      if error
        console.log(error)
        @trigger('authError', error)
      else
        console.log(user)
        @trigger('authSuccess')
        @set 'user', user
    )

  logout: ->
    console.log "logging out"
    @get('auth').logout()
    @set 'user', null

  save: (title) ->
    title ?= "Song #{~~(Math.random()*1000)}"
    cliplist = @get 'cliplist'
    data = {
      tempo: cliplist.params 'tempo'
      clips: []
    }
    cliplist.each( (clip) ->
      data.clips.push({
        notes: clip.get('notes'),
        type: clip.get('type')
      })
    )
    user = @get('user')
    console.log "Sending song data for #{title} to user #{user.id} firebase", data
    fbSong = new Firebase("https://tunesmith.firebaseio.com/songs/#{user.id}/#{title}")
    fbSong.set(data, (error) ->
      console.log(if error then error else "Song saved!")
    )


  load: (title) ->
    fbSong = new Firebase("https://tunesmith.firebaseio.com/songs/#{user.id}/#{title}")
    fbSong.once('value', (toLoad) =>
      cliplist = new Tunesmith.Collections.ClipCollection()
      for clip in toLoad.clips
        cliplist.add(new Tunesmith.Models.ClipModel({type: clip.type, notes: clip.notes}))
      @newSong()
      @set('cliplist', cliplist)
      cliplist.params('tempo', toLoad.tempo)
    )
