`import RemoteSong from "seq25/models/remote-song"`
ApplicationRoute = Ember.Route.extend
  actions:
    openHelp: ->
      @render 'help',
        outlet: 'help'
        into: 'application'

    sendToServer: (song)->
      serializer = @container.lookup('serializer:remote')
      RemoteSong.send(serializer, song)

`export default ApplicationRoute`
