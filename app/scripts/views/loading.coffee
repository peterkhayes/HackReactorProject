'use strict';

class Tunesmith.Views.LoadingView extends Backbone.View

  render: () ->
    @$el.html ''
    @$el.append(Templates["loading"]())
    @arrow = @$el.find('.permissionsArrow')
    @lowestArrowHeight = @arrow.position().top
    @moveArrow()
    @$el

  moveArrow: ->
    top = @arrow.position().top
    if top > 10
      @arrow.animate({
        top: 0
      }, 1000, 'swing', @moveArrow.bind(@))
    else if top == 0
      @lowestArrowHeight *= 2/3
      @arrow.animate({
        top: @lowestArrowHeight
      }, 1000, 'swing', @moveArrow.bind(@))
