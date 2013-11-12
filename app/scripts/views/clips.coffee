'use strict';

class Tunesmith.Views.ClipsView extends Backbone.View

  className: 'clips clearfix'

  initialize: ->
    @collection.on('finishedRecording', @render, @)
    @collection.on('showOptions', @renderOptions, @)

    @currentTab = new Tunesmith.Views.CurrentTabView()

  events: ->
    'mouseup .selector': 'processClick'


  processClick: (e) ->
    command = $(e.target).attr('command') or $(e.target).parent().attr('command')
    type = $(e.target).attr('type') or $(e.target).parent().attr('type')

    switch command
      when 'cancel'
        @render()
      when 'chooseCat'
        @renderSelector([
          {command: 'chooseType', type: 'instrument', name: 'Instrument', image: 'instrument'},
          {command: 'chooseType', type: 'drum', name: 'Drums', image: 'drum'},
          {command: 'chooseType', type: 'live', name: 'Live', image: 'live'},
          {command: 'cancel', name: 'Cancel', image: 'cancel'}
        ], "What kind of clip?")
      when 'chooseType'
        if type == 'instrument'
          @renderSelector([
            {command: 'record', type: 'e_guitar', name: 'E. Guitar', image: 'e_guitar'},
            {command: 'record', type: 'a_guitar', name: 'A. Guitar', image: 'a_guitar'},
            {command: 'record', type: 'bass', name: 'Bass', image: 'bass'},
            {command: 'record', type: 'synth', name: 'Synth', image: 'synth'},
            {command: 'record', type: 'piano', name: 'Piano', image: 'piano'},
            {command: 'record', type: 'sax', name: 'Sax', image: 'sax'},
            {command: 'record', type: 'strings', name: 'Strings', image: 'strings'},
            {command: 'cancel', name: 'Cancel', image: 'cancel'}
          ], "Which instrument?")
        else if type == 'drum'
          @renderSelector([
            {command: 'record', type: 'live_kit', name: 'Live', image: 'live_kit'},
            {command: 'record', type: 'hiphop_kit', name: 'Hip Hop', image: 'hiphop_kit'},
            {command: 'record', type: 'electronic_kit', name: 'Electronic', image: 'electronic_kit'},
            {command: 'cancel', name: 'Cancel', image: 'cancel'}
          ], "Which drum kit?")
      when 'record'
        @renderSelector([
          {command: 'stopRecording', name: "Done", image: "stop"}
        ], "Recording...", true)
        clip = new Tunesmith.Models.ClipModel({type: type, notes: []})
        @collection.add(clip)
        @collection.record(clip)
      when 'stopRecording'
        @collection.stopRecordingAndAddClip()
        @renderSelector([], "Processing...", true) # No buttons here.

  render: ->
    @$el.html ''
    # Attach a current-tab, which keeps track of what's going on.
    @$el.append(@currentTab.render())

    # Put the add new button first.
    @$el.append(Templates['selector']({name: "Add Track", command: "chooseCat", image: "record"}));

    # Then append any clips we've created.
    @collection.each( (clip) =>
      @$el.append (new Tunesmith.Views.ClipView({model: clip}).render())
    )

    @$el


  renderSelector: (buttons, message, bigText) ->
    @$el.html ''
    for button in buttons
      @$el.append(Templates['selector'](button))
    if bigText # If optional 'bigText' is passed in, render inside the list with huge letters.
      @$el.append(Templates['bigText']({text: message}))
    else # Otherwise put it in a pop-up above the cliplist.
      @$el.append(@currentTab.render(message))
    @$el

  renderOptions: (clip) ->
    @editTarget = clip
    @$el.html Templates['selector_options'](clip.attributes)
    @$el.append(@currentTab.render("Options for #{clip.get('type')}"))

  renderRerecorder: ->
    @$el.html Templates['selector_record']()
    @$el.append(@currentTab.render("Rerecording #{@editTarget.get('type')}"))
    @editTarget.clear()
    @collection.record(@editTarget)
    @editTarget = undefined

  renderEditor: ->
    console.log(@editTarget.get('notes'))
    @editTarget = undefined
    @render()