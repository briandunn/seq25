Seq25.TransportController = Ember.ObjectController.extend
  needs: ['partsIndex', 'part']

  song: Ember.computed.alias 'model'

  currentTime: -> Seq25.audioContext.currentTime

  loopHasEnded: -> @get('progress') >= 1

  startedAt: 0
  progress: 0

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
    @get('song').schedule(@get('progress'))

    advancePosition = ->
      @set('progress', @elapsed())
      if @get 'isPlaying'
        Ember.run.later this, advancePosition, 20

    Ember.run.later this, advancePosition, 20

  stop: ->
    @get('song').stop()
    @setProperties
      startedAt: 0
      progress: 0
      isPlaying: false

  actions:
    play: ->
      return if @get('empty')
      if @get('isPlaying') then @stop() else @play()

    addPart: (name) ->
      @get('controllers.partsIndex').send("addPart", name)
