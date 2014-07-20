Seq25.Osc = Ember.Object.extend
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
    @gain.setValueAtTime(1, contextTime)
    @stop(secondsFromNow + duration) if duration
    Seq25.midi.sendOnAt(@get('pitch').name, secondsFromNow)

  stop: (secondsFromNow)->
    contextTime = @get('context').currentTime + secondsFromNow
    if secondsFromNow == 0
      @gain.cancelScheduledValues(@get('context').currentTime)
      Seq25.midi.clearAllScheduled(@get('pitch').name)
    @gain.setValueAtTime(0, contextTime)
    Seq25.midi.sendOffAt(@get('pitch').name, secondsFromNow)
