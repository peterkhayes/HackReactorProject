'use strict';

class Tunesmith.Views.MenuBarView extends Backbone.View

  tagName: 'header'

  render: ->
    @$el.html(Templates["menu_bar"]({user: @model.get('user')}))