window.Tunesmith =
  Models: {}
  Collections: {}
  Views: {}
  Tools: {} # Non-backbone stuff, like the pitch detector and the player
  init: ->
    'use strict'

    loaded = 0
    total = 3
    loadingView = new Tunesmith.Views.LoadingView({el: '#container'})
    loadingView.render(loaded, total)

    #webkit shim
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia
    window.URL = window.URL or window.webkitURL

    # Do we support webaudio?
    try
      audioContext = new window.AudioContext()
    catch e
      alert 'No web audio support in this browser!'

    # Callback to component loading; once all three are loaded, the app starts.
    componentLoaded = =>
      loaded++
      loadingView.render(loaded, total)
      if loaded == total
        appModel = new Tunesmith.Models.AppModel({
          midi: midi
          recorder: recorder
          pitchDetector: pitchDetector
        })

        app = new Tunesmith.Views.AppView({
          el: $('#container')
          model: appModel
        })

    # Load our three pre-loading components.
    midi = new Tunesmith.Models.SoundPlayerModel(componentLoaded, audioContext)
    pitchDetector = new Tunesmith.Models.PitchDetectorModel(componentLoaded, audioContext)
    recorder = new Tunesmith.Models.RecorderModel(componentLoaded, audioContext)

$ ->
  'use strict'
  Tunesmith.init();
