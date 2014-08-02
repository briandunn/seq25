Seq25.PartsIndexRoute = Ember.Route.extend
  model: ->
    song = @modelFor('application')
    'Q W E R A S D F'.w().map (name)-> song.getPart(name)
