Seq25.PitchController = Ember.ObjectController.extend
  needs: ['transport', 'part']
  part: Ember.computed.alias('controllers.part.model')
  beat_count: Ember.computed.alias('part.beat_count')
  instrument: Ember.computed.alias('part.instrument')
  totalTicks: (-> Seq25.Note.TICKS_PER_BEAT * @get('beat_count') ).property('beat_count')

  notes: (->
    @get('part.notes').filter (note)=> note.isPitch @get('model')
  ).property('part.notes.@each', 'beat_count')

  actions:
    addNote: (time)->
      @get('part').addNoteAtPoint(time, @get('model'), @get('controllers.transport').progress())
