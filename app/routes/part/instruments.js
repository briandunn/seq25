const PartInstrumentsRoute = Ember.Route.extend({
  controllerName: 'instruments',

  model() {
    return this.modelFor('part');
  },

  renderTemplate() {
    return this.render({outlet: 'instruments', into: 'song'});
  }
});

export default PartInstrumentsRoute;
