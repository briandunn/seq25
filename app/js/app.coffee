Song = Ember.Object.extend
  tempo: (->
    console.log arguments
    20
  ).property()

  toggle: ->
    if @playing then @stop() else @play()

  play: ->
    for beat in _.select(Seq25.Beat.all, (b)-> b.get('isOn'))
      beat.schedule()
    @playing = true

  stop: ->
    for beat in Seq25.Beat.all
      beat.stop()
    @playing = false

window.Seq25 = Ember.Application.create()

Seq25.Router.map ->

Seq25.IndexRoute = Ember.Route.extend
  init: ->
    song = @model()
    addEventListener 'keydown', (e)->
      if e.keyCode == 32
        song.toggle()

  model: -> new Song

Seq25.BeatController = Ember.ObjectController.extend
  actions:
    toggleNote: ->
      @get('model').toggle()

Seq25.PitchController = Ember.ObjectController.extend
  beats: (->
    [1..8].map (beat)=>
      Seq25.BeatController.create content: new Seq25.Beat(beat, @get('model'))
  ).property()

Seq25.IndexController = Ember.ObjectController.extend
  beats: [1..8]
  pitches: (->
    Seq25.Pitch.all.map (pitch)-> Seq25.PitchController.create content: pitch
  ).property()
  actions:
    setTempo: (val)->
      console.log 'hai'
      @model.set 'tempo', val

Seq25.TempoView = Ember.TextField.extend
  type: 'number'
  attributeBindings: ['min', 'max']
  change: ->
    @get('controller').send 'setTempo', +@get('value')

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
    @pitch.play(@num - 1, 1)

  stop: ->
    @pitch.stop()

  toggle: ->
    @set 'isOn', !@get('isOn')

class Seq25.Pitch
  noteNames = "A A# B C C# D D# E F F# G G#".split ' '
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
    if @isActive()
      @oscilator.stop context.currentTime + secondsFromNow
      @oscilator = getOscilator(@freq)

  do ->
    pitches = for number in [45..69] #[21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
