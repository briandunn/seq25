NOTE_NAMES = "B C C# D D# E F F# G G# A A#".w()
class Seq25.Midi

  connect: ->
    if navigator.requestMIDIAccess
      navigator.requestMIDIAccess().then(@connectSuccess, @connectFailure)
    else
      @connected = false

  connectSuccess: (access)=>
    @output = access.outputs()[0]
    @connected = true if @output

  connectFailure: =>
    console.log("midi connection failure")

  play: (pitch, start, duration)->
    if @connected
      pitch = @translatePitch(pitch)
      VELOCITY = 0x7f
      now = performance.now()
      @sendOnAt(pitch, now + (start * 1e3), VELOCITY)
      @sendOffAt(pitch, now + ((start + duration) * 1e3), VELOCITY) if duration

  sendOnAt: (pitch, timeFromNow, velocity)=>
    ON = 0x90
    @output.send [ON, pitch, velocity], timeFromNow

  sendOffAt: (pitch, timeFromNow, velocity)=>
    OFF = 0x80
    @output.send [ OFF, pitch, velocity], timeFromNow

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
