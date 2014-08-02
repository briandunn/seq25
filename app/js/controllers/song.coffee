Seq25.SongController = Ember.ObjectController.extend
  pitches: (->
    Seq25.Pitch.all.map (pitch)-> Seq25.PitchController.create content: pitch
  ).property()

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  actions:
    setTempo: (val)->
      @get('model').set 'tempo', val
