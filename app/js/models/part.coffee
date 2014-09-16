Seq25.Part = DS.Model.extend
  notes:     DS.hasMany 'note'
  song:      DS.belongsTo 'song'
  name:      DS.attr 'string'
  shape:     DS.attr 'string', defaultValue: 'sine'
  volume:    DS.attr 'number', defaultValue: 0.75
  attack:    DS.attr 'number', defaultValue: 0
  sustain:   DS.attr 'number', defaultValue: 0
  decay:     DS.attr 'number', defaultValue: 0
  resonance: DS.attr 'number', defaultValue: 0
  secondsPerBeat: Ember.computed.alias 'song.secondsPerBeat'

  beat_count: DS.attr 'number', defaultValue: 16
  isMuted: DS.attr 'boolean', defaultValue: false
  instrument: (->
    Seq25.Instrument.create(part: this)
  ).property()

  duration: (->
    @get('secondsPerBeat') * @get('beat_count')
  ).property('secondsPerBeat', 'beat_count')

  offset: (progress)-> progress * @get('duration') * -1

  toggle: (progress)->
    @set('isMuted', !@get('isMuted'))
    if @get('isMuted')
      @stop()
    else
      @schedule(progress)

  schedule: (now, from, to)->
    [now, from, to] = [now, from, to].map (time)=> (Math.round(time * 100) / 100) % @get('duration')
    @get('notes')
    .filter (note)=>
      note.get('absolueSeconds') >= from && note.get('absolueSeconds') < to
    .invoke 'schedule', now

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
