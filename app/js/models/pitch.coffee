NOTE_NAMES = "A A# B C C# D D# E F F# G G#".w()
A0_PITCH = 27.5

Seq25.Pitch = Ember.Object.extend
  pitch: Em.computed -> this

  init: ->
    number = @get('number')
    @set 'name', NOTE_NAMES[(number - 21) % 12] + Math.round((number - 17) / 12)
    @set 'freq', A0_PITCH * Math.pow(2, (number - 21)/12)
    @set 'isSharp', @get('name').indexOf('#') > 0
