context = Seq25.audioContext

Seq25.Osc = Ember.Object.extend
  init: ->
    @oscillator = context.createOscillator()
    gain       = context.createGain()
    gain.gain.value = 0
    @oscillator.connect gain
    gain.connect context.destination
    @oscillator.frequency.value = @get('pitch').freq
    @oscillator.start 0
    @gain = gain.gain
    @_super(this, arguments)

  setShape: (->
    @oscillator.type = @get 'shape'
  ).observes('shape')

  play: (secondsFromNow, duration=null)->
    @gain.setValueAtTime(1, context.currentTime + secondsFromNow)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow)->
    if secondsFromNow == 0
      @gain.cancelScheduledValues(context.currentTime)
    @gain.setValueAtTime(0, (context.currentTime + secondsFromNow))
