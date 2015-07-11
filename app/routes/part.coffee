PartRoute = Ember.Route.extend
  model: ({name})->
    song = @modelFor('song')
    part = song.getPart(name)
    @transitionTo('song', song) unless part
    part

  renderTemplate: ->
    @render 'part-controls', outlet: 'part-controls'
    @_super()

  setupController: (controller, model) ->
    #turning on observers if they've been turned off
    controller.isDestroyed = false
    @controllerFor('transport').set('currentPart', model)
    controller.set('model', model)

  deactivate: ->
    Ember.run.cancel(@controller._positionSaver)
    #turning off observers to enable desctruction of loaded parts
    @controller.isDestroyed = true

  actions:
    incrementQuant: ->
      @get('controller').incrementProperty('quant', 1)

    setQuant: (q)->
      @get('controller').set('quant', q)

`export default PartRoute`
