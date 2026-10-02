import RemoteSong from "seq25/models/remote-song";

const SongRoute = Ember.Route.extend({
  model(param){
    return new Em.RSVP.Promise((resolve, reject)=> {
      return this.store.find('song')
      .then(songs=> {
        const song = songs.findBy('id', param.song_id);
        if (song) {
          return resolve(song);
        } else {
          return RemoteSong.find(this.store, param.song_id)
          .then(song => resolve(song)).catch(() => reject('not found'));
        }
      });
    });
  },

  setupController(controller, song){
    this.controllerFor('transport').set('model', song);
    return controller.set('model', song);
  },

  saveBeforeClose: (function() {
    return Em.$(window).bind('beforeunload', () => {
      this.store.all('song').invoke('save');
      
  });
  }).on('init'),

  actions: {
    addAndGotoPart(name){
      return this.controllerFor('song/index').send('addPart', name);
    }
  }
});

export default SongRoute;
