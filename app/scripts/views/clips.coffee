'use strict';

class Tunesmith.Views.ClipsView extends Backbone.View

  className: 'clips clearfix'

  initialize: ->
    console.log "initialized clip view"
    @collection.on('finishedRecording', @render, @)
    @collection.on('showOptions', @renderOptions, @)

  events: ->
    'click': 'processClick'

  render: ->
    @$el.html ''

    # Put the add new button first.
    @$el.append(Templates['button_add_new']());

    # Then append any clips we've created.
    @collection.each( (clip) =>
      @$el.append (new Tunesmith.Views.ClipView({model: clip}).render())
    )

    @$el

  processClick: (e) ->
    clicked = $(e.target)

    if clicked.hasClass "cancel"
      @render()
    else if clicked.hasClass "add"
      @renderSelector('type')
    else if clicked.hasClass "Instrument"
      @renderRecorder('Instrument')
    else if clicked.hasClass "Drum"
      @renderRecorder('Drum')
    else if clicked.hasClass "live"
      console.log "not yet you quicky!"
    else if clicked.hasClass "stop"
      @stopRecordingAndAddClip()
    else if clicked.hasClass "rerecord"
      @renderRerecorder()
    else if clicked.hasClass "edit"
      @renderEditor()

  renderSelector: (template) ->
    @$el.html Templates['selector_' + template]()
    @$el

  renderRecorder: (type) ->
    console.log 'rendering recorder'
    clip = new Tunesmith.Models.ClipModel({type: type, notes: []})
    @collection.add(clip)
    @$el.html Templates['selector_record']()
    clip.record()

  stopRecordingAndAddClip: ->
    @$el.html Templates['selector_processing']()
    @collection.stopRecordingAndAddClip()

  renderOptions: (clip) ->
    @editTarget = clip
    @$el.html Templates['selector_options'](clip.attributes)

  renderRerecorder: ->
    console.log 'rerecording'
    @$el.html Templates['selector_record']()
    @editTarget.clear()
    @editTarget.record()
    @editTarget = undefined

  renderEditor: ->
    console.log(@editTarget.get('notes'))
    @editTarget = undefined
    @render()



