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
    @get('cliplist').reset()
    @get('cliplist').off()

    newCL = new Tunesmith.Collections.ClipCollection()
    newCL.tools('midi', @get('midi'))
    newCL.tools('recorder', @get('recorder'))
    newCL.tools('pitchDetector', @get('pitchDetector'))
    newCL.tools('metronome', @get('metronome'))
    @set('cliplist', newCL)

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

  save: (title) =>
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
    console.log "Sending song data for #{title} to user #{user.uid} firebase", data
    fbSong = new Firebase("https://tunesmith.firebaseio.com/songs/#{user.uid}/#{title}")
    fbSong.set(data, (error) ->
      console.log(if error then error else "Song #{title} saved!")
    )

  load: (title, success_cb, fail_cb) =>
    console.log("loading #{title} from server")
    fbSong = new Firebase("https://tunesmith.firebaseio.com/songs/#{@get('user').uid}/#{title}")
    fbSong.once('value', (song) =>
      if song.val()
        success_cb(song.val(), title)
      else
        fail_cb(song.val(), title)
    )

  getSongList: (cb) =>
    console.log("getting all of #{@get('user')}'s songs")
    fbSongs = new Firebase("https://tunesmith.firebaseio.com/songs/#{@get('user').uid}")
    fbSongs.once('value', (songs) =>
      console.log(songs.val())
      console.log((song for song of songs.val()))
      cb((song for song of songs.val()))
    )

  generate: (song, title) =>
    console.log("Generating #{title}!")
    cliplist = new Tunesmith.Collections.ClipCollection()
    song.clips ?= []
    for clip in song.clips
      cliplist.add(new Tunesmith.Models.ClipModel({type: clip.type, notes: clip.notes}))
    @newSong()
    @set('cliplist', cliplist)
    cliplist.params('tempo', song.tempo)
    @set('title', title)
