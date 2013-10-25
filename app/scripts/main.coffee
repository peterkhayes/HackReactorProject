window.Tunesmith =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'
    app = new Tunesmith.Views.AppView({el: $('#container')})

$ ->
  'use strict'
  Tunesmith.init();
