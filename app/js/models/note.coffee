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
    ticks = Math.round @get('beat_count') * TICKS_PER_BEAT * @get('position')
    @set 'absoluteTicks', ticks
    @snap(@get('quant'), Math.floor)
  ).observes('beat_count', 'position')

  absoluteTicks: ((_, ticks)->
    if ticks == undefined
      @get('beat') * TICKS_PER_BEAT + @get('tick')
    else
      @setProperties
        beat: Math.floor(ticks / TICKS_PER_BEAT)
        tick: ticks % TICKS_PER_BEAT
      ticks
  ).property('beat', 'tick')

  isPitch: (pitch)->
    @get('pitchNumber') == pitch.number

  ticksToTime: (ticks)->
    (ticks / TICKS_PER_BEAT) * @get('secondsPerBeat')

  secondsPerBeat: (-> 60 / @get('tempo') ).property('tempo')

  snap: (quant, round)->
    return unless quant > 0
    ticksPerGrid = (1 / quant) * TICKS_PER_BEAT
    absoluteTicks = @get('absoluteTicks')
    snappedTicks = round(absoluteTicks / ticksPerGrid) * ticksPerGrid
    if snappedTicks != absoluteTicks
      @set('absoluteTicks', snappedTicks)
      true

  nudge: (quant, round, direction)->
    unless @snap(quant, round)
      ticksPerGrid = (1 / quant) * TICKS_PER_BEAT
      @set('absoluteTicks', @get('absoluteTicks') + (ticksPerGrid * direction))

  nudgeLeft: (quant)->
    @nudge(quant, Math.floor, -1)

  nudgeRight: (quant)->
    @nudge(quant, Math.ceil, 1)

  schedule: (offset)->
    start    = (@get('beat') * @get('secondsPerBeat') + @ticksToTime(@get('tick'))) + offset
    duration = @ticksToTime(@get('duration'))
    @get('instrument').play(@get('pitch'), start, duration)

  stop: ->
    @get('instrument').stop @get 'pitch'

Seq25.Note.TICKS_PER_BEAT = TICKS_PER_BEAT
