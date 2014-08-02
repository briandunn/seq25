class Seq25.Pitch
  noteNames = "A A# B C C# D D# E F F# G G#".w()
  a0Pitch = 27.5
  constructor: (@number)->
    @name = noteNames[(number - 21) % 12] + Math.round((number - 17) / 12)
    @freq = a0Pitch * Math.pow(2, (@number - 21)/12)
    @isSharp = @name.indexOf('#') > 0

  do ->
    pitches = for number in [45..95] #[21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
