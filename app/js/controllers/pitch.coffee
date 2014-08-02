Seq25.PitchController = Ember.ObjectController.extend
  beat_count: Ember.computed.alias('part.beat_count')

  notes: (->
    @get('part.notes').filter (note)=> note.isPitch @get('model')
  ).property('part.notes.@each', 'beat_count')

  actions:
    play: -> Seq25.Osc.play @get('model')
    stop: -> Seq25.Osc.stop @get('model')
    addNote: (time)->
      @get('part').addNoteAtPoint(time, @get('model'))
    removeNote: (note)->
      @get('part').removeNote(note)

