'use strict';

class Tunesmith.Models.AppModel extends Backbone.Model

  initialize: ->
    cliplist = new Tunesmith.Collections.ClipCollection()
    cliplist.tools('midi', @get('midi'))
    cliplist.tools('recorder', @get('recorder'))
    cliplist.tools('pitchDetector', @get('pitchDetector'))
    @set('cliplist', cliplist)

  newSong: ->
    @get('cliplist').resetParams()
    @get('cliplist').reset()

  save: (title) ->
    cliplist = @get 'cliplist'
    data = {
      tempo: cliplist.get 'tempo'
      clips: []
    }
    cliplist.each( (clip) ->
      data.clips.push({
        notes: clip.get('notes'),
        type: clip.get('type')
      })
    )
    console.log data
    Tunesmith.songs[title] = data
    # $.post({
    #   url: "songs/#{title}"
    #   data: data
    # })

  load: (title) ->
    toLoad = Tunesmith.songs[title]
    cliplist = new Tunesmith.Collections.ClipCollection()
    for clip in toLoad.clips
      cliplist.add(new Tunesmith.Models.ClipModel({type: clip.type, notes: clip.notes}))
    @set('cliplist', cliplist)
    @set('tempo', toLoad.tempo)
