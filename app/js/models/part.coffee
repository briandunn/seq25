Seq25.Part = DS.Model.extend
  notes: DS.hasMany 'note'
  song: DS.belongsTo 'song'
  name: DS.attr 'string'
  volume:    DS.attr 'number', default: 0
  attack:    DS.attr 'number', default: 0
  sustain:   DS.attr 'number', default: 0
  decay:     DS.attr 'number', default: 0
  resonance: DS.attr 'number', default: 0

  beat_count: DS.attr 'number', defaultValue: 16
  isMuted: DS.attr 'boolean', defaultValue: false
  instrument: (->
    Seq25.Instrument.create(part: this)
  ).property('volume', 'attack', 'sustain', 'decay', 'resonance')

  toggle: ->
    @set('isMuted', !@get('isMuted'))

  schedule: (tempo)->
    @get('notes').forEach (note)->
        note.schedule(tempo)

  stop: ->
    @get('notes').forEach (note)->
      note.stop()

  addNoteAtPoint: (position, pitch)->
    note = @get('notes').createRecord
      pitchNumber: pitch.number
      position:    position
      beat_count:  @get('beat_count')

    @save()
    note.save()

  removeNote:(note)->
    note.stop()
    @get('notes').removeRecord(note)
    @save()
    note.destroy()
