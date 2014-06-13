context = Seq25.audioContext

class Seq25.Osc
  constructor: (pitch)->
    oscillator = context.createOscillator()
    gain       = context.createGain()
    gain.gain.value = 0
    oscillator.connect gain
    gain.connect context.destination
    oscillator.frequency.value = pitch.freq
    oscillator.start 0
    @gain = gain.gain

  play: (secondsFromNow, duration=null)->
    @gain.setValueAtTime(1, context.currentTime + secondsFromNow)
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow)->
    @gain.setValueAtTime(0, (context.currentTime + secondsFromNow))
    if secondsFromNow == 0
      @gain.cancelScheduledValues(0)

  @oscillators = {}

  @play = (pitch, secondsFromNow=0, duration=null)->
    (@oscillators[pitch.number] ||= new @(pitch)).play(secondsFromNow, duration)

  @stop = (pitch, secondsFromNow=0)->
    @oscillators[pitch.number]?.stop(secondsFromNow)
