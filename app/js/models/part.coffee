eachInstrument = ->
  for _, value of @getProperties 'midiInstruments', 'synthesizers'
    value.invoke.apply value, arguments

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

  totalTicks: Em.computed 'beat_count', ->
    Seq25.Note.TICKS_PER_BEAT * @get('beat_count')

  duration: Em.computed 'secondsPerBeat', 'beat_count', ->
    @get('secondsPerBeat') * @get('beat_count')

  toggle: ->
    @toggleProperty 'isMuted'

  schedule: (now, from, to)->
    {duration, notes} = @getProperties 'duration', 'notes'
    loopOffset = Math.floor(from / duration) * duration
    notes.forEach (note)=>
      start = loopOffset + note.get 'absolueSeconds'
      while start < to
        if start >= from
          eachInstrument.call this, 'play', note, start - now
        start += duration

  stop: (pitch)->
    eachInstrument.call this, 'stop', pitch

  play: (pitch)->
    eachInstrument.call this, 'play', pitch

  addNoteAtPoint: (position, quant)->
    @get('notes').createRecord
      position:   position
      beat_count: @get('beat_count')
      quant:      quant

  addNote: (pitchNumber, ticks, duration, quant)->
    @get('notes').createRecord
      pitchNumber:   pitchNumber
      absoluteTicks: ticks
      duration:   duration
      quant:      quant

  destroyRecord: ->
    for collection in 'synthesizers midiInstruments notes'.w()
      @get(collection).invoke 'destroyRecord'
    @_super()

  bumpVolume: (direction, multiplier=1) ->
    amount = 0.1 * multiplier
    amount = amount * -1 if direction == "down"
    @incrementProperty('volume', amount)
