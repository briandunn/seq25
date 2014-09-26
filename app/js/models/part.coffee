Seq25.Part = DS.Model.extend
  notes:      DS.hasMany 'note'
  song:       DS.belongsTo 'song'
  name:       DS.attr 'string'
  shape:      DS.attr 'string', defaultValue: 'sine'
  volume:     DS.attr 'number', defaultValue: 0.75
  attack:     DS.attr 'number', defaultValue: 0
  release:  DS.attr 'number', defaultValue: 0
  filterFreq: DS.attr 'number', defaultValue: 1
  filterQ:    DS.attr 'number', defaultValue: 0
  secondsPerBeat: Ember.computed.alias 'song.secondsPerBeat'

  beat_count: DS.attr 'number', defaultValue: 16
  isMuted: DS.attr 'boolean', defaultValue: false

  instrument: Em.computed ->
    Seq25.Instrument.create part: this

  duration: Em.computed 'secondsPerBeat', 'beat_count', ->
    @get('secondsPerBeat') * @get('beat_count')

  toggle: (progress)->
    @set('isMuted', !@get('isMuted'))
    if @get('isMuted')
      @stop()
    else
      @schedule(progress)

  schedule: (now, from, to)->
    {duration, notes} = @getProperties 'duration', 'notes'
    loopOffset = Math.floor(from / duration) * duration
    now = now - loopOffset
    to = to   - loopOffset
    notes.forEach (note)->
      loopRelativeStart = note.get 'absolueSeconds'
      loopCount = 0
      while (start = loopRelativeStart - (now - (duration * loopCount))) < to
        note.schedule start
        loopCount += 1

  stop: ->
    @get('notes').invoke 'stop'

  addNoteAtPoint: (position, pitchNumber, quant)->
    @get('notes').createRecord
      pitchNumber: pitchNumber
      position:    position
      beat_count:  @get('beat_count')
      quant:       quant

  removeNote:(note)->
    note.stop()
    @get('notes').removeRecord(note)
    @save()
    note.destroy()

  bumpVolume: (direction, multiplier=1) ->
    amount = 0.1 * multiplier
    amount = amount * -1 if direction == "down"
    @incrementProperty('volume', amount)
