const SongIndexRoute = Ember.Route.extend({
  model() {
    return this.modelFor('song');
  },

  renderTemplate() {
    return this.render('parts/index', {into: 'song'});
  }
});

export default SongIndexRoute;
