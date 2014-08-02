Seq25.PitchController = Ember.ObjectController.extend
  notes: (->
    @get('part').get('notes').filter (note)=>
      note.isPitch @get('model')
  ).property('part.notes.@each', 'beat_count')
  beat_count: (-> @get('part').get('beat_count')).property('part.beat_count')
  actions:
    play: -> Seq25.Osc.play @get('model')
    stop: -> Seq25.Osc.stop @get('model')
    addNote: (time)->
      @get('part').addNoteAtPoint(time, @get('model'))
    removeNote: (note)->
      @get('part').removeNote(note)

