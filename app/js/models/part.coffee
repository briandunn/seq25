calls = 0
Seq25.Part = DS.Model.extend
  notes:           DS.hasMany 'note'
  synthesizers:    DS.hasMany 'synthesizer'
  midiInstruments: DS.hasMany 'midiInstrument'
  song:            DS.belongsTo 'song'
  name:            DS.attr 'string'
  volume:          DS.attr 'number', defaultValue: 0.75
  beat_count:      DS.attr 'number', defaultValue: 16
  isMuted:         DS.attr 'boolean', defaultValue: false
  secondsPerBeat: Em.computed.alias 'song.secondsPerBeat'
  instruments:    Em.computed 'synthesizers.[]', 'midiInstruments.[]', ->
    {synthesizers, midiInstruments} = @getProperties 'synthesizers', 'midiInstruments'
    synthesizers.toArray().concat midiInstruments.toArray()

  duration: Em.computed 'secondsPerBeat', 'beat_count', ->
    @get('secondsPerBeat') * @get('beat_count')

  toggle: (progress)->
    @set('isMuted', !@get('isMuted'))

  schedule: (now, from, to)->
    {duration, notes, instruments} = @getProperties 'duration', 'notes', 'instruments'
    loopOffset = Math.floor(from / duration) * duration
    notes.forEach (note)->
      start = loopOffset + note.get 'absolueSeconds'
      while start < to
        if start >= from
          instruments.invoke 'play', note, start - now
        start += duration

  stop: ->
    @get('instruments').invoke 'stop'

  addNoteAtPoint: (position, pitchNumber, quant)->
    @get('notes').createRecord
      pitchNumber: pitchNumber
      position:    position
      beat_count:  @get('beat_count')
      quant:       quant

  removeNote:(note)->
    @get('notes').removeRecord(note)
    @save()
    note.destroy()

  bumpVolume: (direction, multiplier=1) ->
    amount = 0.1 * multiplier
    amount = amount * -1 if direction == "down"
    @incrementProperty('volume', amount)
