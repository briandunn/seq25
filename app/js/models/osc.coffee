Seq25.Osc = Ember.Object.extend
  attack:    Em .computed.alias 'instrument.attack'
  context:   Em .computed.alias 'instrument.context'
  output:    Em .computed.alias 'instrument.output'
  resonance: Em .computed.alias 'instrument.resonance'
  shape:     Em .computed.alias 'instrument.shape'

  init: ->
    {context, output, pitch} = @getProperties 'context', 'output', 'pitch'
    @oscillator = context.createOscillator()
    gain        = context.createGain()
    gain.gain.value = 0
    @oscillator.connect gain
    gain.connect output
    @oscillator.frequency.value = pitch.freq
    @oscillator.start 0
    @gain = gain.gain
    @_super()

  setShape: (->
    @oscillator.type = @get('shape')
  ).observes('shape').on('init')

  play: (secondsFromNow, duration=null)->
    {context, attack} = @getProperties 'context', 'attack'
    contextTime = context.currentTime + secondsFromNow
    @gain.setValueAtTime 0, contextTime
    @gain.linearRampToValueAtTime(1, contextTime + attack)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow)->
    {context, resonance} = @getProperties 'context', 'resonance'
    contextTime = context.currentTime + secondsFromNow
    @gain.cancelScheduledValues(contextTime)
    @gain.linearRampToValueAtTime(0, contextTime + resonance)
