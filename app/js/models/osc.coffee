Seq25.Osc = Ember.Object.extend
  attack:     Em.computed.alias 'synthesizer.attack'
  context:    Em.computed.alias 'synthesizer.context'
  filterFreq: Em.computed.alias 'synthesizer.filterFreq'
  filterQ:    Em.computed.alias 'synthesizer.filterQ'
  output:     Em.computed.alias 'synthesizer.output'
  release:    Em.computed.alias 'synthesizer.release'
  shape:      Em.computed.alias 'synthesizer.shape'

  init: ->
    {context, output, pitch} = @getProperties 'context', 'output', 'pitch'
    @oscillator = context.createOscillator()
    @filter     = context.createBiquadFilter()
    gain        = context.createGain()
    gain.gain.value = 0
    @oscillator.connect @filter
    @filter.connect gain
    gain.connect output
    @oscillator.frequency.value = pitch.get('freq')
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
    {context, filterFreq} = @getProperties 'context', 'filterFreq'
    @filter.frequency.value = filterFreq * (context.sampleRate / 2)
  ).observes('filterFreq').on 'init'

  play: (secondsFromNow, duration=null)->
    {context, attack} = @getProperties 'context', 'attack'
    contextTime = context.currentTime + secondsFromNow
    @gain.setValueAtTime 0, contextTime
    @gain.linearRampToValueAtTime(1, contextTime + attack)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow=0)->
    {context, release} = @getProperties 'context', 'release'
    contextTime = context.currentTime + secondsFromNow
    @gain.linearRampToValueAtTime(0, contextTime + release)
