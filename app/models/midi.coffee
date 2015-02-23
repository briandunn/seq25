class Seq25.Midi
  constructor: (@output)->

  play: (pitch, velocity, channel, start=0, duration)->
    now = performance.now()
    noteOnTime = now + (start * 1e3)
    @sendOnAt(pitch, velocity, channel, noteOnTime)
    noteOffTime = now + ((start + duration) * 1e3)
    @sendOffAt(pitch, channel, noteOffTime) if duration

  stop: (pitch, channel)->
    @sendOffAt(pitch, channel, 0)

  sendOnAt: (pitch, velocity, channel, timeFromNow)->
    ON = 0x90 ^ channel
    @output.send [ON, pitch, Math.floor(velocity * 127)], timeFromNow

  sendOffAt: (pitch, channel, timeFromNow)->
    OFF = 0x80 ^ channel
    @output.send [OFF, pitch, 0x7f], timeFromNow

connectionPromise = null
Seq25.Midi.connect = ->
  connectionPromise ||= new Em.RSVP.Promise (resolve, reject) ->
    navigator.requestMIDIAccess()
    .then (access)->
      if output = access.outputs.values().next().value
        resolve(new Seq25.Midi(output))
      else
        console.log 'connected, but no outputs'
        reject()
    .catch ->
      console.log "midi connection failure"
      reject()
