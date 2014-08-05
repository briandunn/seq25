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
  tempo: Ember.computed.alias('song.tempo')

  beat_count: DS.attr 'number', defaultValue: 16
  isMuted: DS.attr 'boolean', defaultValue: false
  instrument: (->
    Seq25.Instrument.create(part: this)
  ).property()

  duration: (-> @get('beat_count') * 60 / @get('tempo')).property('beat_count', 'tempo')

  offset: (progress)-> progress * @get('duration') * -1

  toggle: (progress)->
    @set('isMuted', !@get('isMuted'))
    if @get('isMuted')
      @stop()
    else
      @schedule(progress)

  schedule: (progress)->
    @get('notes').forEach (note)=>
      note.schedule @offset progress

  stop: ->
    @get('notes').forEach (note)->
      note.stop()

  addNoteAtPoint: (position, pitch, quant)->
    @get('notes').createRecord
      pitchNumber: pitch.number
      position:    position
      beat_count:  @get('beat_count')
      quant:       quant

  removeNote:(note)->
    note.stop()
    @get('notes').removeRecord(note)
    @save()
    note.destroy()

  bumpVolume: (direction) ->
    amount = 0.1
    amount = amount * -1 if direction == "down"
    @incrementProperty('volume', amount)
