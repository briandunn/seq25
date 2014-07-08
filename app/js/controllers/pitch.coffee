Seq25.PitchController = Ember.ObjectController.extend
  beat_count: Ember.computed.alias('part.beat_count')
  instrument: Ember.computed.alias('part.instrument')

  notes: (->
    @get('part.notes').filter (note)=> note.isPitch @get('model')
  ).property('part.notes.@each', 'beat_count')

  actions:
    play: -> @get('instrument').play @get('model')
    stop: -> @get('instrument').stop @get('model')
    addNote: (time)->
      @get('part').addNoteAtPoint(time, @get('model'))
    removeNote: (note)->
      @get('part').removeNote(note)

