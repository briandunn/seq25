const SongsIndexRoute = Ember.Route.extend({
  model() {
    return this.store.find('song');
  }
});

export default SongsIndexRoute;
