'use strict';

class Tunesmith.Views.ClipsView extends Backbone.View

  className: 'clips clearfix'

  initialize: ->
    @listenTo(@collection, 'finishedRecording', @render)
    @listenTo(@collection, 'edit', @renderEditor)

    # @collection.on('finishedRecording', @render, @)
    # @collection.on('edit', @renderEditor, @)

    @currentTab = new Tunesmith.Views.CurrentTabView()

  events: {
    'mouseup .selector': 'processClick'
  }

  processClick: (e) ->
    command = $(e.target).attr('command') or $(e.target).parent().attr('command')
    type = $(e.target).attr('type') or $(e.target).parent().attr('type')

    @renderSpecial(command, type)

  # If no arguments are passed in, render the default view in the cliplist.
  render: (buttons, message, bigText) ->
    @$el.html ''

    if bigText # If optional 'bigText' is passed in, render inside the list with huge letters.
      @$el.append(Templates['bigText']({text: message}))
    else # Otherwise put it the message in a pop-up above the cliplist.
      @$el.append(@currentTab.render(message))

    if buttons
      for button in buttons
        @$el.append(Templates['selector'](button))
    else
      @$el.append(Templates['selector']({name: "Add Track", command: "chooseCat", image: "record"}));
      @collection.each( (clip) =>
        @$el.append(new Tunesmith.Views.ClipView({model: clip}).render())
      )

    @$el

  renderSpecial: (command, type) ->
    switch command
      when 'cancel'
        @render()
      when 'chooseCat'
        @render([
          {command: 'chooseType', type: 'instrument', name: 'Instrument', image: 'instrument'},
          {command: 'chooseType', type: 'drum', name: 'Drums', image: 'drum'},
          {command: 'chooseType', type: 'live', name: 'Live', image: 'live'},
          {command: 'cancel', name: 'Cancel', image: 'cancel'}
        ], "What kind of clip?")
        @editTarget = null # We're adding a new clip, so we'll need a blank recording destination
      when 'chooseType'
        if type == 'instrument'
          @render([
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
          @render([
            {command: 'record', type: 'live_kit', name: 'Live', image: 'live_kit'},
            {command: 'record', type: 'hiphop_kit', name: 'Hip Hop', image: 'hiphop_kit'},
            {command: 'record', type: 'dance_kit', name: 'Dance', image: 'dance_kit'},
            {command: 'cancel', name: 'Cancel', image: 'cancel'}
          ], "Which drum kit?")
      when 'record'
        @render([
          {command: 'stopRecording', name: "Done", image: "stop"}
        ], "Recording...", true)
        if @editTarget
          clip = @editTarget
          clip.clear()
        else
          clip = new Tunesmith.Models.ClipModel({type: type, notes: []})
          @collection.add(clip)
        @collection.record(clip)
      when 'stopRecording'
        @collection.stopRecordingAndAddClip()
        @render([], "Processing...", true) # No buttons here, so pass in []
      when 'delete'
        console.log(@editTarget)
        @collection.remove(@editTarget)
        @render()
      when 'edit'
        @render([
          {command: 'record', name: 'Rerecord', image: 'record'},
          {command: 'delete', name: 'Delete', image: 'delete'},
          {command: 'cancel', name: 'Cancel', image: 'cancel'}
        ], "Editing #{@editTarget.get('type')}")


  renderEditor: (clip) ->
    console.log "editing...", clip
    @editTarget = clip
    @renderSpecial('edit')

  renderRerecorder: ->
    @$el.html Templates['selector_record']()
    @$el.append(@currentTab.render("Rerecording #{@editTarget.get('type')}"))
    @editTarget.clear()
    @collection.record(@editTarget)
    @editTarget = undefined