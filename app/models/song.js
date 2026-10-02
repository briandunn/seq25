const Song = DS.Model.extend({
  parts:    DS.hasMany('part'),
  remoteId: DS.attr('number'),
  tempo:    DS.attr('number', {defaultValue: 120}),
  secondsPerBeat: (function() { return 60 / this.get('tempo');  }).property('tempo'),

  getPart(name){
    return this.get('parts').findBy('name', name);
  },

  schedule(now, from, to){
    return this.get('parts').invoke('schedule', now, from, to);
  },

  stop() {
    return this.get('parts').invoke('stop');
  },

  notes: Em.computed('parts.@each.notes', function() {
    return this.get('parts')
    .map(part => part.get('notes').toArray())
    .reduce(((all, some) => all.concat(some)), []);
}),

  didDelete() {
    return this.get('parts').invoke('destroyRecord');
  }
});

export default Song;
