BUFFER_TIME = 0.02
Seq25.TransportController = Ember.ObjectController.extend
  needs: 'partsIndex'

  song: Ember.computed.alias 'model'

  currentTime: -> Seq25.audioContext.currentTime

  loopHasEnded: -> @get('progress') >= 1

  startedAt: 0
  progress: 0
  scheduledUntil: 0

  isPlaying: false

  beat: (->
    Math.floor((@elapsed() * @get('tempo')) / 60)
  ).property('progress')

  elapsed: ->
    return 0 unless @get('startedAt') > 0
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
      return if @get('empty')
      if @get('isPlaying') then @stop() else @play()

    addPart: (name) ->
      @get('controllers.partsIndex').send("addPart", name)
