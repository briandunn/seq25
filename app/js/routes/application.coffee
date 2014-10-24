Seq25.ApplicationRoute = Ember.Route.extend
  actions:
    openHelp: ->
      this.render 'help',
        outlet: 'help'
        into: 'application'
