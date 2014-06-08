context = Seq25.Pitch.context
bufferSize = 256
window.script = context.createJavaScriptNode bufferSize, 0, 1
gain = context.createGain()
gain.gain.value = 0
script.connect gain
gain.connect context.destination
script.onaudioprocess = (event)->
  out = event.outputBuffer.getChannelData 0
  _.times bufferSize, (i)->
    out[i] = Math.random()

window.snare = ->
  gain.gain.setValueAtTime 1, context.currentTime
  gain.gain.linearRampToValueAtTime 0, (context.currentTime + 0.15)
