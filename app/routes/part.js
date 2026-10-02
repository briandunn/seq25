const PartRoute = Ember.Route.extend({
  model({name}){
    const song = this.modelFor('song');
    const part = song.getPart(name);
    if (!part) { this.transitionTo('song', song); }
    return part;
  },

  renderTemplate() {
    this.render('part-controls', {outlet: 'part-controls'});
    return this._super();
  },

  setupController(controller, model) {
    //turning on observers if they've been turned off
    controller.isDestroyed = false;
    this.controllerFor('transport').set('currentPart', model);
    return controller.set('model', model);
  },

  deactivate() {
    Ember.run.cancel(this.controller._positionSaver);
    //turning off observers to enable desctruction of loaded parts
    return this.controller.isDestroyed = true;
  },

  actions: {
    incrementQuant() {
      return this.get('controller').incrementProperty('quant', 1);
    },

    setQuant(q){
      return this.get('controller').set('quant', q);
    }
  }
});

export default PartRoute;
