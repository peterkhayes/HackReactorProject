window.Tunesmith =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'

    loading = 0

    componentLoaded = =>
      loading++
      if loading == 3
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
