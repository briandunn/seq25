NOTE_NAMES = "B C C# D D# E F F# G G# A A#".w()
class Seq25.Midi
  constructor: ->
    @scheduled = {"A2": []}

  connect: ->
    navigator.requestMIDIAccess().then(@connectSuccess, @connectFailure)

  connectSuccess: (access)=>
    @output = access.outputs()[0]
    @connected = true if @output

  connectFailure: =>
    console.log("midi connection failure")

  sendOnAt: (pitch, timeFromNow) ->
    scheduledOn = setTimeout((=> @sendOn(pitch)), timeFromNow * 1000)
    (@scheduled[pitch] ||= []).push(scheduledOn)

  sendOffAt: (pitch, timeFromNow) ->
    scheduledOff = setTimeout((=> @sendOff(pitch)), timeFromNow * 1000)
    (@scheduled[pitch] ||= []).push(scheduledOff)

  clearAllScheduled: (pitch) ->
    if @scheduled[pitch]
      for timeout in @scheduled[pitch]
        clearTimeout(timeout)

  sendOn: (pitch="A4", velocity=0x7f)=>
    pitch = @translatePitch(pitch)
    ON = 0x90
    if @connected
      @output.send( [ ON, pitch, velocity ] )

  sendOff: (pitch="A4", velocity=0x7f)=>
    pitch = @translatePitch(pitch)
    OFF = 0x80
    if @connected
      @output.send( [ OFF, pitch, velocity ] )

  translatePitch: (pitch="A4")->
    bottomA = 0x47 - 24
    [octave, note] = @splitPitch(pitch)
    return bottomA + (NOTE_NAMES.indexOf(note) + (12 * (octave - 2)))

  splitPitch: (pitch)->
    octave = pitch[2] || pitch[1]
    note = pitch.replace(octave, '')
    return [octave, note]

Seq25.midi = new Seq25.Midi()
Seq25.midi.connect()
