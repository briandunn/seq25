Seq25.SongController = Ember.ObjectController.extend

  songSaver: ( ->
    @get('model').save()
  ).observes('tempo')
