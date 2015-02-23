ApplicationRoute = Ember.Route.extend
  actions:
    openHelp: ->
      @render 'help',
        outlet: 'help'
        into: 'application'

`export default ApplicationRoute`
