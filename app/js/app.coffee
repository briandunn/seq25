window.Seq25 = Ember.Application.create()
Seq25.Router.map ->

Seq25.IndexRoute = Ember.Route.extend
  beats: [1..8]
  model: ->
    Seq25.Pitch.all

Seq25.PitchController = Ember.ObjectController.extend
  beats: [1..8]
  actions:
    play: ->
      @get('model').play()

Seq25.IndexController = Ember.ArrayController.extend
  itemController: 'pitch'

Seq25.PianoKeyView = Ember.View.extend
  tagName: 'th'
  model: -> @get('controller').get('model')

  mouseLeave: -> @model().stop()
  mouseUp:    -> @model().stop()
  mouseDown:  -> @model().play()

Ember.Handlebars.helper 'piano-key', Seq25.PianoKeyView

class Seq25.Pitch
  noteNames = ['A','A#','B','C','C#','D','D#','E','F','F#','G','G#']
  a0Pitch = 27.5
  context = new window.AudioContext
  getOscilator = (freq)->
    oscilator = context.createOscillator()
    oscilator.connect context.destination
    oscilator.frequency.value = freq
    oscilator

  constructor: (@number)->
    @name = noteNames[(number - 21) % 12] + Math.round((number - 17) / 12)
    @freq = a0Pitch * Math.pow(2, (@number - 21)/12)
    @isSharp = @name.indexOf('#') > 0
    @oscilator = getOscilator(@freq)

  isPlaying: ->
    @oscilator.playbackState == @oscilator.PLAYING_STATE

  play: ->
    return if @isPlaying()
    @oscilator.start 0

  stop: ->
    return unless @isPlaying()
    @oscilator.stop 0
    @oscilator = getOscilator(@freq)

  do ->
    pitches = for number in [21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
