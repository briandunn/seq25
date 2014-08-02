Seq25.PartController = Ember.ObjectController.extend
  pitches: (-> Seq25.Pitch.all).property('model')
  needs: 'transport'
  progress: Em.computed.alias('controllers.transport.progress')
  quant: 1

  playBarStyle: (->
      "left: #{@get('progress') * 100}%"
  ).property('progress')

  selectedNotes: []

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  beatCountSaver: ( ->
    @get('model').save()
  ).observes('beat_count', 'notes.[]')

  noteSaver: ( ->
    @get('notes').invoke 'save'
  ).observes('notes.[]')

  durationSaver: ( ->
    @get('selectedNotes').invoke 'save'
  ).observes('selectedNotes.@each.duration')

  editResolution: (-> @get('quant') * Seq25.Note.TICKS_PER_BEAT ).property('quant')

  actions:
    removeNotes: ->
      @get('selectedNotes').forEach (note) =>
        @get('model').removeNote(note)

    extendNotes: ->
      @get('selectedNotes').forEach (note) =>
        note.set('duration', note.get('duration') + @get('editResolution'))

    shortenNotes: ->
      @get('selectedNotes').forEach (note) =>
        note.set('duration', note.get('duration') - @get('editResolution'))

    nudgeLeft: ->
      @get('selectedNotes').invoke 'nudgeLeft', @get('quant')

    nudgeRight: ->
      @get('selectedNotes').forEach (note) =>
        note.set('tick', note.get('tick') + @get('editResolution'))
