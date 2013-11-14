'use strict';

class Tunesmith.Views.SaveView extends Backbone.View

  className: 'popup save'

  events: {
    'click button.close': 'close'
    'click button.submit': 'submit'
    'click button.overwrite': 'save'
    'click button.noOverwrite': -> @render()
    'keyup input': (e) -> if e.keyCode == 13 then @submit()
    'keyup': (e) -> if e.keyCode == 27 then @close()
  }

  render: (existingTitle) ->
    $('#greyout').show()
    @$el.html(Templates['save']({user: @model.get('user'), existingTitle: existingTitle}))
    @$el.appendTo('body')

  close: ->
    @$el.detach()
    $('#greyout').hide()

  submit: ->
    title = @$el.find('.title').val()
    console.log "title is #{title}"
    @model.load(
      title,
      (song, title) =>
        @render(title)
      (song, title) =>
        @save(title)
    )

  save: (title) ->
    if typeof title == "object" then title = @$el.find('.title').text()
    console.log "title is #{title}"
    @model.save(title)
    @close()

  error: (err) ->
    @$el.find('.error').text(err)
