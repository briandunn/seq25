Seq25.Part = DS.Model.extend
  notes:        DS.hasMany 'note'
  synthesizers: DS.hasMany 'synthesizer'
  song:         DS.belongsTo 'song'
  name:         DS.attr 'string'
  volume:       DS.attr 'number', defaultValue: 0.75
  beat_count:   DS.attr 'number', defaultValue: 16
  isMuted:      DS.attr 'boolean', defaultValue: false
  secondsPerBeat: Em.computed.alias 'song.secondsPerBeat'
  instruments:    Em.computed.alias 'synthesizers'

  duration: Em.computed 'secondsPerBeat', 'beat_count', ->
    @get('secondsPerBeat') * @get('beat_count')

  toggle: (progress)->
    @set('isMuted', !@get('isMuted'))
    if @get('isMuted')
      @stop()
    else
      @schedule(progress)

  schedule: (now, from, to)->
    {duration, notes, instruments} = @getProperties 'duration', 'notes', 'instruments'
    loopOffset = Math.floor(from / duration) * duration
    now = now - loopOffset
    to = to   - loopOffset
    notes.forEach (note)->
      loopRelativeStart = note.get 'absolueSeconds'
      loopCount = 0
      while (start = loopRelativeStart - (now - (duration * loopCount))) < to
        instruments.invoke 'play', note, start
        loopCount += 1

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
