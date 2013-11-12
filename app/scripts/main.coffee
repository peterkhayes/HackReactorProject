window.Tunesmith =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'

    loaded = 0
    loadingView = new Tunesmith.Views.LoadingView({el: '#container'})
    loadingView.render(loaded)

    # Callback to component loading; once all three are loaded, the app starts.
    componentLoaded = =>
      loaded++
      loadingView.render(loaded)
      if loaded == 4
        appModel = new Tunesmith.Models.AppModel({
          midi: midi
          recorder: recorder
          pitchDetector: pitchDetector
          metronome: metronome
        })

        app = new Tunesmith.Views.AppView({
          el: $('#container')
          model: appModel
        })

    #webkit shim
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia
    window.URL = window.URL or window.webkitURL

    try
      audioContext = new window.AudioContext()
    catch e
      alert 'No web audio support in this browser!'

    # Load our three pre-loading components.
    midi = new Tunesmith.Models.MidiModel(componentLoaded, audioContext)
    recorder = new Tunesmith.Models.RecorderModel(componentLoaded, audioContext)
    pitchDetector = new Tunesmith.Models.PitchDetectorModel(componentLoaded, audioContext)
    metronome = new Tunesmith.Models.MetronomeModel(componentLoaded, audioContext)

    # Useful for testing midi events.
    window.p = (num) =>
      midi.play('piano', {note: num, len: 1})

$ ->
  'use strict'
  Tunesmith.init();

  # A test song until I get a DB running.
  Tunesmith.songs = {
    mySong: {
      tempo: 160
      clips: [
        {
          notes: [{pitch: 64, len: 4, vel: 96}, {pitch:0, len: 0, vel:0}, {pitch:0, len: 0, vel:0}, {pitch:0, len: 0, vel:0}]
          type: "instrument"
        }
      ]
    }
  }
