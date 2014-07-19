Seq25.PartRoute = Ember.Route.extend
  model: (params)->
    @modelFor('application').get('parts').findBy('name', params.name)
