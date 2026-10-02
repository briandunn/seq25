import RemoteSong from "seq25/models/remote-song";
const SongsIndexController = Ember.ArrayController.extend({
  init() {
    this._super();
    return this.set('remoteSongs', []);
  },

  refreshRemoteSongs: (function() {
    return RemoteSong.all().then(songs=> {
      return this.set('remoteSongs', songs);
  });
  }).observes('@each.remoteId').on('init'),

  actions: {
    addSong() {
      const song = this.store.createRecord('song');
      return this.transitionToRoute('song', song);
    },

    removeSong(song){
      if (Ember.testing || confirm('!')) {
        return song.destroyRecord();
      }
    }
  }
});

export default SongsIndexController;
