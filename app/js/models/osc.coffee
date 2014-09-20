Seq25.Osc = Ember.Object.extend
  attack:  Em.computed.alias 'instrument.attack'
  context: Em.computed.alias 'instrument.context'
  output:  Em.computed.alias 'instrument.output'
  shape:   Em.computed.alias 'instrument.shape'

  init: ->
    context = @get('context')
    @oscillator = context.createOscillator()
    gain       = context.createGain()
    gain.gain.value = 0
    @oscillator.connect gain
    gain.connect @get('output')
    @oscillator.frequency.value = @get('pitch').freq
    @oscillator.start 0
    @gain = gain.gain
    @_super(arguments)

  setShape: (->
    @oscillator.type = @get('shape')
  ).observes('shape').on('init')

  play: (secondsFromNow, duration=null)->
    contextTime = @get('context').currentTime + secondsFromNow
    @gain.setValueAtTime(0, contextTime)
    @gain.linearRampToValueAtTime(1, contextTime + @get('attack'))
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow)->
    contextTime = @get('context').currentTime + secondsFromNow
    @gain.cancelScheduledValues(contextTime)
    @gain.setValueAtTime(0, contextTime)
