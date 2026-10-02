const BUFFER_TIME = 0.5;
const PROGRESS_INTERVAL = 50;
const TransportController = Ember.Controller.extend({
  song: Ember.computed.alias('model'),

  context: Em.computed(function() { return this.container._registry.resolve('audioContext:main'); }),
  currentTime() { return this.get('context').currentTime; },
  startedAt: 0,
  progress: 0,
  scheduledUntil: 0,
  isPlaying: false,

  tempo: Em.computed.alias('song.tempo'),

  beat: Em.computed('progress', 'tempo', function() {
    return Math.floor((this.get('progress') * this.get('tempo')) / 60);
  }),

  elapsed() {
    if (!this.get('isPlaying')) { return 0; }
    return this.currentTime() - this.get('startedAt');
  },

  play() {
    this.setProperties({
      startedAt: this.currentTime(),
      isPlaying: true,
      scheduledUntil: BUFFER_TIME
    });

    let {progress, song, scheduledUntil} = this.getProperties('progress', 'song', 'scheduledUntil');

    song.schedule(progress, progress, scheduledUntil);

    var advancePosition = function() {
      if (!this.get('isPlaying')) { return; }
      this.set('progress', this.elapsed());
      progress = this.get('progress');
      scheduledUntil = this.get('scheduledUntil');
      if ((progress + BUFFER_TIME) > scheduledUntil) {
        const newScheduleEnd = scheduledUntil + BUFFER_TIME;
        song.schedule(progress, scheduledUntil, newScheduleEnd);
        this.set('scheduledUntil', newScheduleEnd);
      }
      return Ember.run.later(this, advancePosition, PROGRESS_INTERVAL);
    };

    return Ember.run.later(this, advancePosition, PROGRESS_INTERVAL);
  },

  stop() {
    this.get('song').stop();
    return this.setProperties({
      scheduledUntil: 0,
      startedAt: 0,
      progress: 0,
      isPlaying: false
    });
  },

  muteAll() {
   return this.setMuteForAll(true);
 },

  unmuteAll() {
    return this.setMuteForAll(false);
  },

  setMuteForAll(val) {
    return this.get('song.parts').forEach( part => part.set('isMuted', val));
  },

  actions: {
    play() {
      if (this.get('isPlaying')) { return this.stop(); } else { return this.play(); }
    },

    gotoPart(part){
      return this.transitionToRoute('part', part);
    }
  }
});

export default TransportController;
