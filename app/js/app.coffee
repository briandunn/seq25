Song = Ember.Object.extend
  tempo: 120

  beats: [1..16]

  notes: []

  toggle: ->
    if @playing then @stop() else @play()

  play: ->
    scheduleNotes = =>
      for note in @get('notes')
        note.schedule()
    scheduleNotes()
    @playing = true
    startTime = Seq25.Pitch.context.currentTime
    movePlayBar = =>
      elapsed = Seq25.Pitch.context.currentTime - startTime
      $('#play').css(left: "#{elapsed * 100}%")
      return unless @playing
      if elapsed > 1
        scheduleNotes()
        startTime += elapsed
      requestAnimationFrame movePlayBar

    requestAnimationFrame movePlayBar

  stop: ->
    for note in @get('notes')
      note.stop()
    @playing = false

  addNoteAtPoint: (time, pitch)->
    # translate from fraction of loop to seconds from start
    # beatsPerSecond = @get('tempo') / 60
    # loopDuration = @get('beats').length * beatsPerSecond
    start = time #* loopDuration
    @get('notes').addObject new Note start, pitch

  removeNote:(note)->
    @get('notes').removeObject(note)

window.song = Song.create()

window.Seq25 = Ember.Application.create()

Seq25.Router.map ->

Seq25.IndexRoute = Ember.Route.extend
  init: ->
    song = @model()
    addEventListener 'keydown', (e)->
      if e.keyCode == 32
        e.preventDefault()
        song.toggle()

  model: -> new Song

Seq25.PitchController = Ember.ObjectController.extend
  notes: (->
    @get('song').get('notes').filter (note)=>
      note.isPitch @get('model')
  ).property('song.notes.@each')
  song: song
  actions:
    addNote: (time)->
      @get('song').addNoteAtPoint(time, @get('model'))
    removeNote: (note)->
      @get('song').removeNote(note)

Seq25.IndexController = Ember.ObjectController.extend
  pitches: (->
    Seq25.Pitch.all.map (pitch)-> Seq25.PitchController.create content: pitch
  ).property()
  actions:
    setTempo: (val)->
      @get('model').set 'tempo', val

Seq25.TempoView = Ember.TextField.extend
  type: 'number'
  attributeBindings: ['min', 'max']
  change: ->
    @triggerAction
      action: 'setTempo',
      actionContext: +@get('value')

Seq25.PianoKeyView = Ember.View.extend
  model: -> @get('controller').get('model')
  attributeBindings: ['class']
  classNames: ['row']
  tagName: 'li'

  mouseLeave: -> @model().stop()
  mouseUp:    -> @model().stop()
  mouseDown:  -> @model().play()

Seq25.NoteListView = Ember.CollectionView.extend
  itemView: 'note'
  tagName: 'ul'
  classNames: ['notes']
  itemViewClass: Ember.View.extend
    click: ->
      @get('controller').send 'removeNote', @get('content')
      false

    didInsertElement: ->
      time = @get('content').get('start')
      @$().css(left: "#{time * 100}%")

  click: (e)->
    time = e.offsetX / @get('element').offsetWidth
    @get('controller').send 'addNote', time

Ember.Handlebars.helper 'piano-key', Seq25.PianoKeyView
Ember.Handlebars.helper 'note-list', Seq25.NoteListView

Note = Ember.Object.extend
  init: (@start, @pitch)->
    @constructor.all ?= []
    @constructor.all.push this

  isPitch: (pitch)->
    @pitch.name == pitch.name

  schedule: ->
    @pitch.play(@start, 0.25)

  stop: ->
    @pitch.stop()

class Seq25.Pitch
  noteNames = "A A# B C C# D D# E F F# G G#".split ' '
  a0Pitch = 27.5
  context = new window.AudioContext
  @context = context
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
    pitches = for number in [45..95] #[21..108]
      new Pitch(number)
    Pitch.all = pitches.reverse()
