'use strict';

class Tunesmith.Views.ClipsView extends Backbone.View

  className: 'clips clearfix'

  initialize: ->
    console.log "initialized clip view"
    @collection.on('finishedRecording', @render, @)
    @collection.on('showOptions', @renderOptions, @)

    @currentTab = new Tunesmith.Views.CurrentTabView()

  events: ->
    'click': 'processClick'

  render: ->
    @$el.html ''
    # Attach a current-tab, which keeps track of what's going on.
    @$el.append(@currentTab.render())

    # Put the add new button first.
    @$el.append(Templates['selector']({name: "Add Track", type: "add", image: "record"}));

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
      @renderSelector('type', "Choose which type of clip.")


    else if clicked.hasClass "instruments"
      @renderRecorder('piano')
    else if clicked.hasClass "drums"
      @renderRecorder('hiphop_kit')
    # else if clicked.hasClass "instruments"
    #   @renderSelector('instruments')
    # else if clicked.hasClass "drums"
    #   @renderSelector('drums')
    # else if clicked.hasClass 'instrument'
    #   @renderRecorder(clicked.attr('instrument'))
    else if clicked.hasClass "live"
      console.log "not yet you quicky!"
    else if clicked.hasClass "stop"
      @stopRecordingAndAddClip()
    else if clicked.hasClass "rerecord"
      @renderRerecorder()
    else if clicked.hasClass "edit"
      @renderEditor()

  renderSelector: (template, message) ->
    @$el.html Templates['selector']()
    @$el.append(@currentTab.render(message))
    @$el

  renderRecorder: (type) ->
    console.log 'rendering recorder'
    clip = new Tunesmith.Models.ClipModel({type: type, notes: []})
    @$el.html Templates['selector_record']()
    @$el.append(@currentTab.render('Recording...'))
    @collection.add(clip)
    @collection.record(clip)

  stopRecordingAndAddClip: ->
    @$el.html Templates['selector_processing']()
    @$el.append(@currentTab.render('Working...'))
    @collection.stopRecordingAndAddClip()


  renderOptions: (clip) ->
    @editTarget = clip
    @$el.html Templates['selector_options'](clip.attributes)
    @$el.append(@currentTab.render("Options for #{clip.get('type')}"))

  renderRerecorder: ->
    console.log 'rerecording'
    @$el.html Templates['selector_record']()
    @$el.append(@currentTab.render("Rerecording #{@editTarget.get('type')}"))
    @editTarget.clear()
    @collection.record(@editTarget)
    @editTarget = undefined

  renderEditor: ->
    console.log(@editTarget.get('notes'))
    @editTarget = undefined
    @render()



