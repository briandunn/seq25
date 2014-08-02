TICKS_PER_BEAT = 96
Seq25.Note = DS.Model.extend
  pitchNumber: DS.attr 'number'
  beat:        DS.attr 'number'
  tick:        DS.attr 'number'
  part:        DS.belongsTo 'part'
  duration:    DS.attr 'number', defaultValue: TICKS_PER_BEAT
  tempo: Ember.computed.alias 'part.tempo'

  instrument: Ember.computed.alias 'part.instrument'
  pitch: (-> Seq25.Pitch.all.findBy('number', @get('pitchNumber'))).property('pitchNumber')

  setBeatAndTick: (->
    beatFraction = @get('beat_count') * @get('position')
    beat = Math.floor beatFraction
    tick = Math.floor (beatFraction - beat) * TICKS_PER_BEAT

    @setProperties beat: beat, tick: tick
  ).observes('beat_count', 'position')

  isPitch: (pitch)->
    @get('pitchNumber') == pitch.number

  ticksToTime: (ticks)->
    (ticks / TICKS_PER_BEAT) * @get('secondsPerBeat')

  secondsPerBeat: (-> 60 / @get('tempo') ).property('tempo')

  schedule: (offset)->
    start    = (@get('beat') * @get('secondsPerBeat') + @ticksToTime(@get('tick'))) + offset
    duration = @ticksToTime(@get('duration'))
    @get('instrument').play(@get('pitch'), start, duration)

  stop: ->
    @get('instrument').stop @get 'pitch'

Seq25.Note.TICKS_PER_BEAT = TICKS_PER_BEAT
