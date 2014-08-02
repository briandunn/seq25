Seq25.PitchController = Ember.ObjectController.extend
  needs: ['transport', 'part']
  part: Ember.computed.alias('controllers.part.model')
  beat_count: Ember.computed.alias('part.beat_count')
  instrument: Ember.computed.alias('part.instrument')

  notes: Ember.computed.filter 'part.notes', (note)->
    note.isPitch @get('model')

  actions:
    addNote: (time)->
      @get('part').addNoteAtPoint(time, @get('model'), @get('controllers.transport.progress'))
