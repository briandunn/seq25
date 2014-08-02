Seq25.ApplicationRoute = Ember.Route.extend
  model: ->
    Seq25.Song.loadDefault(@store)

  setupController: (controller, song)->
    song.save()
    @controllerFor('transport').set('model', song)
    controller.set('model', song)
    @setupPitches()

  setupPitches: ->
    pitches = for number in [45..95] #[21..108]
      Seq25.Pitch.create(number: number)
    Seq25.Pitch.all = pitches.reverse()
