Seq25.PartController = Ember.ObjectController.extend
  pitches: (->
    Seq25.Pitch.all.map (pitch)=>
      Seq25.PitchController.create content: pitch, part: @get('model')
  ).property('model')

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  actions:
    setBeatCount: (val)->
      @get('model').set 'beatCount', val
