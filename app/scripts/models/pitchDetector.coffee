'use strict';

class Tunesmith.Models.PitchDetectorModel extends Backbone.Model

  initialize: (cb) ->
    @set "pitch", new PitchAnalyzer(44100);
    cb()

  getNote: (frequency) ->
    if (frequency)
      Math.round(69 + 12 * Math.log(frequency / 440) / Math.LN2)
    else
      0

  chunk: (buffer, tempo, minInterval) ->
    chunkLength = Math.round(2646000 / minInterval / tempo)
    end = buffer.length - chunkLength;
    (buffer.subarray(x, x + chunkLength) for x in [0..end] by chunkLength)

  convertToPitches: (chunks) ->
    pitches = []
    pitch = @get 'pitch'
    for chunk in chunks
      pitch.input(chunk)
      pitch.process()
      tone = pitch.findTone() or {freq: 0, db: -90}
      pitches.push {pitch: @getNote(tone.freq), vel: 2*(tone.db + 90), len: 1}
    pitches

  merge: (notes) ->
    for note, i in notes
      if prev and prev.pitch == note.pitch
        prev.len++
        note.pitch = 0
      else
        prev = note
    notes

  standardizeClipLength: (notes, minInterval) ->
    len = notes.length
    prevPowerOf2 = Math.pow(2, Math.floor(Math.log(len)/Math.LN2))
    nextPowerOf2 = Math.pow(2, Math.ceil(Math.log(len)/Math.LN2))

    if (len - prevPowerOf2) < minInterval
      notes = notes.slice(0, prevPowerOf2)
    else
      while (notes.length < nextPowerOf2)
        notes.push({pitch:0, vel: 0, len: 1})

    notes

  convertToNotes: (buffer, tempo, minInterval) ->
    chunks = @chunk(buffer, tempo, minInterval)
    pitches = @convertToPitches(chunks)
    merged = @merge(pitches)
    stdzd = @standardizeClipLength(merged, minInterval)
    console.log stdzd
    return stdzd