import RemoteSong from "seq25/models/remote-song";
const ApplicationRoute = Ember.Route.extend({
  actions: {
    openHelp() {
      return this.render('help', {
        outlet: 'help',
        into: 'application'
      }
      );
    },

    sendToServer(song){
      const serializer = this.container.lookup('serializer:remote');
      return RemoteSong.send(serializer, song);
    }
  }
});

export default ApplicationRoute;
