Seq25.Part = DS.Model.extend
  notes: DS.hasMany 'note'
  song: DS.belongsTo 'song'
  name: DS.attr 'string'
  beat_count: DS.attr 'number', defaultValue: 16
  isMuted: DS.attr 'boolean', defaultValue: false

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
