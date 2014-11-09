Seq25.PartRoute = Ember.Route.extend
  model: (params)->
    @modelFor('song').get('parts').findBy('name', params.name)

  renderTemplate: ->
    @render 'part-controls', outlet: 'part-controls'
    @_super()

  setupController: (controller, model) ->
    #turning on observers if they've been turned off
    controller.isDestroyed = false
    controller.set('model', model)

  deactivate: ->
    Ember.run.cancel(@controller._positionSaver)
    #turning off observers to enable desctruction of loaded parts
    @controller.isDestroyed = true
