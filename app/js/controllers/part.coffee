Seq25.PartController = Ember.ObjectController.extend
  pitches: (-> Seq25.Pitch.all).property('model')

  selectedNotes: []

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  beatCountSaver: ( ->
    @get('model').save()
  ).observes('beat_count')

  actions:
    removeNotes: ->
      @get('selectedNotes').forEach (note) =>
        @get('model').removeNote(note)

    extendNotes: ->
      @get('selectedNotes').forEach (note) =>
        note.set('duration', note.get('duration') + 5)

    shortenNotes: ->
      @get('selectedNotes').forEach (note) =>
        note.set('duration', note.get('duration') - 5)
