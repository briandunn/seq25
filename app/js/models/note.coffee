Seq25.Note = DS.Model.extend
  pitchNumber: DS.attr 'number'
  beat:        DS.attr 'number'
  tick:        DS.attr 'number'
  part:        DS.belongsTo 'part'
  tempo: Ember.computed.alias 'part.tempo'

  instrument: Ember.computed.alias 'part.instrument'
  pitch: (-> Seq25.Pitch.all.findBy('number', @get('pitchNumber'))).property('pitchNumber')

  setBeatAndTick: (->
    beatFraction = @get('beat_count') * @get('position')
    beat = Math.floor beatFraction
    tick = Math.floor (beatFraction - beat) * 96

    @set('beat', beat)
    @set('tick', tick)
  ).observes('beat_count', 'position')

  isPitch: (pitch)->
    @get('pitchNumber') == pitch.number

  schedule: (offset)->
    beatDuration = 60 / @get('tempo')
    start = (@get('beat') * beatDuration) + ((@get('tick') / 96) * beatDuration) + offset
    @get('instrument').play(@get('pitch'), start, 0.1)

  stop: ->
    @get('instrument').stop @get 'pitch'
