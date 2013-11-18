'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    @newSong()

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

  newSong: (newSong, title) =>
    console.log "making a new song with data: ", newSong

    if @get('cliplist')
      @get('cliplist').reset()
      @get('cliplist').off()

    maxTime = 0
    if newSong and newSong.clips
      for clip in newSong.clips
        console.log clip
        if clip.notes.length > maxTime
          maxTime = clip.notes.length

    newSong = newSong or {}
    newSong.tempo = newSong.tempo or 120

    recorder = @get('recorder')
    midi = @get('midi')

    recorder.stop()
    recorder.clear()
    midi.clear()

    newCL = new Tunesmith.Collections.ClipCollection(newSong.clips)

    newCL.params('tempo', newSong.tempo)
    if maxTime then newCL.params('maxTime', maxTime)
    newCL.tools('midi', midi)
    newCL.tools('recorder', recorder)
    newCL.tools('pitchDetector', @get('pitchDetector'))
    newCL.tools('metronome', @get('metronome'))

    newCL.each( (clip) ->
      midi.loadInstrument(clip.get('type'))
    )

    @listenTo(newCL, 'change', @attemptToSave)
    @set('cliplist', newCL)
    @set('title', title)
    @trigger('clearSong')

  login: (email, pass) =>
    console.log("attempting to log in...")
    @get('auth').login('password', {
        email: email
        password: pass
      })

  signup: (email, pass) =>
    console.log("attempting to sign up...")
    @get('auth').createUser(email, pass, (error, user) =>
      console.log @
      if error
        console.log(error)
        @trigger('authError', error)
      else
        console.log(user)
        @set 'user', user
        @trigger('authSuccess')
    )

  logout: ->
    console.log "logging out"
    @get('auth').logout()
    @set 'user', null

  attemptToSave: =>
    if @get('user')
      title = @get('title') || '---Unsaved Work---'
      @save('Unsaved Work')

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
    @set('title', title)

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
    console.log("getting all of #{@get('user').uid}'s songs")
    fbSongs = new Firebase("https://tunesmith.firebaseio.com/songs/#{@get('user').uid}")
    fbSongs.once('value', (songs) =>
      console.log(songs.val())
      console.log((song for song of songs.val()))
      cb((song for song of songs.val()))
    )
