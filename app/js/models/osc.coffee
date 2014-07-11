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
    @_super(this, arguments)
    @setShape()

  setShape: (->
    @oscillator.type = @get('shape')
  ).observes('shape')

  play: (secondsFromNow, duration=null)->
    @gain.setValueAtTime(1, @get('context').currentTime + secondsFromNow)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow)->
    if secondsFromNow == 0
      @gain.cancelScheduledValues(@get('context').currentTime)
    @gain.setValueAtTime(0, (@get('context').currentTime + secondsFromNow))
