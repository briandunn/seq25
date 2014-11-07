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

  totalTicks: Em.computed 'beat_count', ->
    Seq25.Note.TICKS_PER_BEAT * @get('beat_count')

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

  addNoteAtPoint: (position, quant)->
    @get('notes').createRecord
      position:   position
      beat_count: @get('beat_count')
      quant:      quant

  destroyRecord: ->
    for collection in 'synthesizers midiInstruments notes'.w()
      @get(collection).invoke 'destroyRecord'
    @_super()

  bumpVolume: (direction, multiplier=1) ->
    amount = 0.1 * multiplier
    amount = amount * -1 if direction == "down"
    @incrementProperty('volume', amount)
