'use strict';

class Tunesmith.Views.SaveView extends Backbone.View

  className: 'popup save'

  events: {
    'click button.close': 'close'
    'click button.submit': 'submit'
    'click button.overwrite': 'save'
    'click button.noOverwrite': 'render'
  }

  render: (existingTitle) ->
    $('#greyout').show()
    @$el.html(Templates['save']({existingTitle: existingTitle}))
    @$el.appendTo('body')

  close: ->
    @$el.remove()
    $('#greyout').hide()

  submit: ->
    title = @$el.find('.title').val()
    console.log('looking up #{title}')
    @model.checkIfAlreadySaved(title, (exists) =>
      if exists
        @render(title)
      else
        @save()
    )

  save: ->
    title = @$el.find('.title').val()
    @model.save(title)
    @close()

  error: (err) ->
    @$el.find('.error').text(err)
