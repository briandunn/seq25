Seq25.PitchController = Ember.ObjectController.extend
  needs: ['transport', 'part']
  part: Ember.computed.alias('controllers.part.model')
  beat_count: Ember.computed.alias('part.beat_count')
  instrument: Ember.computed.alias('part.instrument')

  notes: (->
    @get('part.notes').filter (note)=> note.isPitch @get('model')
  ).property('part.notes.@each.pitchNumber', 'beat_count')

  actions:
    addNote: (time)->
      note = @get('part').addNoteAtPoint time, @get('model').number, @get('controllers.part.quant')
      if @get('controllers.transport.isPlaying')
        note.schedule -@get('controllers.transport').elapsed()
