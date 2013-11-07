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

    componentLoaded = =>
      loaded++
      loadingView.render(loaded)
      if loaded == 3
        appModel = new Tunesmith.Models.AppModel({
          midi: midi
          recorder: recorder
          pitchDetector: pitchDetector
        })

        app = new Tunesmith.Views.AppView({
          el: $('#container')
          model: appModel
        })

    midi = new Tunesmith.Models.MidiModel(componentLoaded)
    recorder = new Tunesmith.Models.RecorderModel(componentLoaded)
    pitchDetector = new Tunesmith.Models.PitchDetectorModel(componentLoaded)

$ ->
  'use strict'
  Tunesmith.init();
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
