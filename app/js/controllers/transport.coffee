BUFFER_TIME = 0.02
Seq25.TransportController = Ember.ObjectController.extend
  needs: ['partsIndex', 'part']

  song: Ember.computed.alias 'model'
  currentTime: -> Seq25.audioContext.currentTime
  startedAt: 0
  progress: 0
  scheduledUntil: 0
  isPlaying: false

  beat: Em.computed 'progress', 'tempo', ->
    Math.floor (@get('progress') * @get('tempo')) / 60

  elapsed: ->
    return 0 unless @get 'isPlaying'
    @currentTime() - @get('startedAt')

  play: ->
    @setProperties
      startedAt: @currentTime()
      isPlaying: true
      scheduledUntil: 2*BUFFER_TIME

    {progress, song, scheduledUntil} = @getProperties 'progress', 'song', 'scheduledUntil'

    song.schedule progress, progress, scheduledUntil

    advancePosition = ->
      return unless @get 'isPlaying'
      @set('progress', @elapsed())
      {progress, scheduledUntil} = @getProperties 'progress', 'scheduledUntil'
      if (progress + BUFFER_TIME) > scheduledUntil
        song.schedule(progress, scheduledUntil, scheduledUntil + 2*BUFFER_TIME)
        @incrementProperty 'scheduledUntil', 2*BUFFER_TIME
      Ember.run.later this, advancePosition, BUFFER_TIME * 1000

    Ember.run.later this, advancePosition, BUFFER_TIME * 1000

  stop: ->
    @get('song').stop()
    @setProperties
      scheduledUntil: 0
      startedAt: 0
      progress: 0
      isPlaying: false

  actions:
    play: ->
      if @get('isPlaying') then @stop() else @play()

    addPart: (name) ->
      @get('controllers.partsIndex').send "addPart", name
