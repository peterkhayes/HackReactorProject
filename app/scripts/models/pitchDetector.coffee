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
      ac_tone = detectPitch(chunk)
      pitch.input(chunk)
      pitch.process()
      tone = pitch.findTone() or {freq: 0, db: -90}
      pitches.push {pitch: @getNote(tone.freq), vel: 2*(tone.db + 90), len: 1, ac: @getNote(ac_tone)}
    pitches

  merge: (notes) ->
    sustained = notes[0]
    for note, i in notes
      next = notes[i+1]
      dnext = notes[i+2]
      if sustained and (sustained.pitch > 0) and (note.ac > 20) and (note.pitch == 0)
        note.pitch = sustained.pitch

      if next and (sustained.pitch > 0) and (sustained.pitch == next.pitch)
        note.pitch = sustained.pitch

      if next and dnext and (15 > note.pitch - sustained.pitch > 7) and (15 > note.pitch - next.pitch > 7) and (15 > note.pitch - dnext.pitch > 7)
        note.pitch -= 12

      if next and dnext and (Math.abs(note.pitch - next.pitch) == 1) and (Math.abs(note.pitch - dnext.pitch) == 1)
        note.pitch = next.pitch

      if note.pitch == sustained.pitch
        note.pitch = 0
        sustained.len++

      if note.pitch != sustained and note.pitch != 0
        sustained = note
      # console.log sustained
      # console.log notes[i-1]
      # console.log "---"
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

  convertToNotes: (buffer) ->
    tempo = @get('player').tempo
    minInterval = @get('player').minInterval

    chunks = @chunk(buffer, tempo, minInterval)
    pitches = @convertToPitches(chunks)
    merged = @merge(pitches)
    stdzd = @standardizeClipLength(merged, minInterval)
    return stdzd