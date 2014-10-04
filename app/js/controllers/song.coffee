Seq25.SongController = Ember.ObjectController.extend

  tempoSaver: ( ->
    @get('model').save()
  ).observes('tempo')
