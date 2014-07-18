Seq25.PartController = Ember.ObjectController.extend
  pitches: (-> Seq25.Pitch.all).property('model')

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  beatCountSaver: ( ->
    @get('model').save()
  ).observes('beat_count')
