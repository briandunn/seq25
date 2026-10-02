const SongIndexController = Ember.Controller.extend({
  song: Em.computed.alias('model'),
  parts: (function() {
    const song = this.get('song');
    return 'Q W E R A S D F'.w().map(name => song.getPart(name) || {name, placeholder: true});
  }).property('song.parts.[]'),

  actions: {
    addPart(name){
      const part = this.get('song.parts').createRecord({name});
      part.get('synthesizers').createRecord();

      return this.transitionToRoute('part', name);
    },

    removePart(part){
      return part.destroyRecord();
    }
  }
});

export default SongIndexController;
