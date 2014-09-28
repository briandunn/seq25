VELOCITY = 0x7f
class Seq25.Midi
  constructor: (@output)->

  play: (pitch, channel, start, duration)->
    now = performance.now()
    noteOnTime = now + (start * 1e3)
    @sendOnAt(pitch, channel, noteOnTime)
    noteOffTime = now + ((start + duration) * 1e3)
    @sendOffAt(pitch, channel, noteOffTime) if duration

  sendOnAt: (pitch, channel, timeFromNow)->
    ON = 0x90 ^ channel
    @output.send [ON, pitch, VELOCITY], timeFromNow

  sendOffAt: (pitch, channel, timeFromNow)->
    OFF = 0x80 ^ channel
    @output.send [ OFF, pitch, VELOCITY], timeFromNow

connectionPromise = null
Seq25.Midi.connect = ->
  connectionPromise ||= new Em.RSVP.Promise (resolve, reject) ->
    navigator.requestMIDIAccess()
    .then (access)->
      if output = access.outputs()[0]
        resolve(new Seq25.Midi(output))
      else
        console.log 'connected, but no outputs'
        reject()
    .catch ->
      console.log "midi connection failure"
      reject()
