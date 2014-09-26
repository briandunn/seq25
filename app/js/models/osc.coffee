Seq25.Osc = Ember.Object.extend
  attack:     Em.computed.alias 'instrument.attack'
  context:    Em.computed.alias 'instrument.context'
  filterFreq: Em.computed.alias 'instrument.filterFreq'
  filterQ:    Em.computed.alias 'instrument.filterQ'
  output:     Em.computed.alias 'instrument.output'
  release:  Em.computed.alias 'instrument.release'
  shape:      Em.computed.alias 'instrument.shape'

  init: ->
    {context, output, pitch} = @getProperties 'context', 'output', 'pitch'
    @oscillator = context.createOscillator()
    @filter     = context.createBiquadFilter()
    gain        = context.createGain()
    gain.gain.value = 0
    @oscillator.connect @filter
    @filter.connect gain
    gain.connect output
    @oscillator.frequency.value = pitch.freq
    @oscillator.start 0
    @gain = gain.gain
    @_super()

  setShape: (->
    @oscillator.type = @get 'shape'
  ).observes('shape').on 'init'

  setFilterQ: (->
    @filter.Q.value = @get('filterQ') * 1000
  ).observes('filterQ').on 'init'

  setFilterFreq: (->
    @filter.frequency.value = @get('filterFreq') * (@get('context').sampleRate / 2)
  ).observes('filterFreq').on 'init'

  play: (secondsFromNow, duration=null)->
    {context, attack} = @getProperties 'context', 'attack'
    contextTime = context.currentTime + secondsFromNow
    @gain.setValueAtTime 0, contextTime
    @gain.linearRampToValueAtTime(1, contextTime + attack)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow)->
    {context, release} = @getProperties 'context', 'release'
    contextTime = context.currentTime + secondsFromNow
    @gain.cancelScheduledValues(contextTime)
    @gain.linearRampToValueAtTime(0, contextTime + release)
