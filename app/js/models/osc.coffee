Seq25.Osc = Ember.Object.extend
  attack:     Em.computed.alias 'synthesizer.attack'
  context:    Em.computed.alias 'synthesizer.context'
  filterFreq: Em.computed.alias 'synthesizer.filterFreq'
  filterQ:    Em.computed.alias 'synthesizer.filterQ'
  output:     Em.computed.alias 'synthesizer.output'
  release:    Em.computed.alias 'synthesizer.release'
  shape:      Em.computed.alias 'synthesizer.shape'

  init: ->
    {context, output} = @getProperties 'context', 'output'
    @filter = context.createBiquadFilter()
    gain    = context.createGain()
    gain.gain.value = 0
    @filter.connect gain
    gain.connect output
    @gain = gain.gain

    @oscillator = context.createOscillator()
    @oscillator.frequency.value = @get 'pitch.freq'
    @oscillator.start 0

    @noise = context.createScriptProcessor(1 << 14)
    @noise.onaudioprocess = (event)->
      for channel in [0, 1]
        out = event.outputBuffer.getChannelData channel
        out[i] = Math.random() for i in [0..event.outputBuffer.length]

    @_super()

  setShape: (->
    {shape, context} = @getProperties 'shape', 'context'
    if shape == 'noise'
      @oscillator.disconnect()
      @noise.connect @filter
    else
      @noise.disconnect()
      @oscillator.type = @get 'shape'
      @oscillator.connect @filter
  ).observes('shape').on 'init'

  setFilterQ: (->
    @filter.Q.value = @get('filterQ') * 100
  ).observes('filterQ').on 'init'

  setFilterFreq: (->
    {context, filterFreq} = @getProperties 'context', 'filterFreq'
    @filter.frequency.value = filterFreq * (context.sampleRate / 2)
  ).observes('filterFreq').on 'init'

  play: (secondsFromNow, rampTo=1, duration=null)->
    {context, attack} = @getProperties 'context', 'attack'
    contextTime = context.currentTime + secondsFromNow
    @gain.setValueAtTime 0, contextTime
    @gain.linearRampToValueAtTime(rampTo, contextTime + attack)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow=0)->
    {context, release} = @getProperties 'context', 'release'
    contextTime = context.currentTime + (secondsFromNow - 0.003)
    @gain.linearRampToValueAtTime(0, contextTime + release)
