class Song
  tempo: 60
  play: ->
    for beat in _.select(Seq25.Beat.all, (b)-> b.get('isOn'))
      beat.schedule()

  stop: ->
    for beat in Seq25.Beat.all
      beat.stop()

song = new Song

window.onkeydown = (e)->
  if e.keyCode == 32
    song.play()
  else
    song.stop()

window.Seq25 = Ember.Application.create()

Seq25.Router.map ->

Seq25.IndexRoute = Ember.Route.extend
  model: ->
    Seq25.Pitch.all

Seq25.ApplicationView = Ember.View.extend
  keyUp: -> alert 'boom!'
  didInsertElement: -> @$().focus()

Seq25.BeatController = Ember.ObjectController.extend
  updateCollection: Ember.computed 'isOn', ->

  actions:
    toggleNote: ->
      @get('model').toggle()

Seq25.PitchController = Ember.ObjectController.extend
  beats: null
  init: ->
    beats = _.map [1..8], (beat)=>
      Seq25.BeatController.create content: new Seq25.Beat(beat, @get('model'))
    @set('beats', beats)

Seq25.IndexController = Ember.ArrayController.extend
  beats: [1..8]
  itemController: 'pitch'

Seq25.PianoKeyView = Ember.View.extend
  tagName: 'th'
  model: -> @get('controller').get('model')

  mouseLeave: -> @model().stop()
  mouseUp:    -> @model().stop()
  mouseDown:  -> @model().play()

Ember.Handlebars.helper 'piano-key', Seq25.PianoKeyView

Seq25.Beat = Ember.Object.extend
  isOn: false
  init: (@num, @pitch)->
    @constructor.all ?= []
    @constructor.all.push this

  schedule: ->
    console.log(@num - 1, @num, @pitch.name)
    @pitch.play(@num - 1)
    @pitch.stop(@num)

  stop: ->
    @pitch.stop()

  toggle: ->
    @set 'isOn', !@get('isOn')

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

  isScheduled: ->
    @oscilator.playbackState == @oscilator.SCHEDULED_STATE

  isActive: ->
    @isScheduled() or @isPlaying()

  play: (secondsFromNow=0, duration=null)->
    return if @isActive()
    @oscilator.start context.currentTime + secondsFromNow
    @stop(secondsFromNow + duration) if duration

  stop: (secondsFromNow=0)->
    return unless @isActive()
    @oscilator.stop context.currentTime + secondsFromNow
    @oscilator = getOscilator(@freq)

  do ->
    pitches = for number in [45..69] #[21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
